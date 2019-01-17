#!/usr/bin/env python3
"""
capsize.py

Checks to see if a deployment is older than a configured age
and triggers a rolling restart if they are too old.
"""
import os
import json
from datetime import datetime
import logging
import pytz
from kubernetes import client, config

# Config from environment variables
namespace = os.environ.get("KUBE_NAMESPACE", "istio-system")
deploymentName = os.environ.get("KUBE_DEPLOY_NAME", "istio-ingressgateway")
containerName = os.environ.get("KUBE_CONTAINER_NAME", "istio-proxy")
maxAge = int(os.environ.get("MAX_POD_AGE", 30 * 3600 * 24))
logLevel = os.environ.get("LOG_LEVEL", "INFO").upper()
configType = os.environ.get("CONFIG_TYPE", "cluster")

# Get the time and initialize some things
now = datetime.utcnow().replace(tzinfo=pytz.utc)
nowUnix = int(now.strftime("%s"))
podAges = []
triggerRestart = False

# Configure Logging
formatter = logging.Formatter('%(asctime)s  %(levelname)8s  %(message)s')
logger = logging.getLogger(__name__)
sh = logging.StreamHandler()
sh.setFormatter(formatter)
logger.setLevel(logLevel)
logger.addHandler(sh)

logger.info("CONFIG  %15s: %s", 'namespace', namespace)
logger.info("CONFIG  %15s: %s", 'deploymentName', deploymentName)
logger.info("CONFIG  %15s: %s", 'containerName', containerName)
logger.info("CONFIG  %15s: %s", 'maxAge', maxAge)
logger.info("CONFIG  %15s: %s", 'logLevel', logLevel)
logger.info("CONFIG  %15s: %s", 'configType', configType)


def rollDeployment():
    """
    Patches the deployment to trigger a reboot
    """
    extApi = client.ExtensionsV1beta1Api()
    body = """{"spec":{"template":{"spec":{"containers":[{"name":\
        "","env":[{"name":"LAST_MANUAL_RESTART",\
        "value":""}]}]}}}}"""
    patch = json.loads(body)
    patch['spec']['template']['spec']['containers'][0]['name'] = containerName
    patch['spec']['template']['spec']['containers'][0]['env'][0]['value'] \
        = str(nowUnix)
    logger.debug("Patch created: %s", json.dumps(patch, indent=2))
    logger.info("Applying patch to restart ingressgateway")
    ret = extApi.patch_namespaced_deployment(deploymentName,
                                             namespace, patch, pretty=True)
    logger.debug(ret)


# Setup Kubernetes access
if configType == "cluster":
    config.load_incluster_config()
    logger.info("Using in-cluster config")
elif configType == "local":
    config.load_kube_config()
    logger.info("Using local kubeconfig")

coreApi = client.CoreV1Api()
podRet = coreApi.list_namespaced_pod(namespace)

if len(podRet.items) is not 0:
    for pod in podRet.items:
        podName = pod.metadata.name
        status = pod.status.phase
        if deploymentName in podName and status == 'Running':
            podAge = now - pod.status.start_time
            logger.debug('Found pod %s that is %ds old',
                         podName, podAge.seconds)

            if (podAge.total_seconds() > maxAge):
                logger.info("Found pod that triggers restart: %s", podName)
                triggerRestart = True
            else:
                logger.info("Not triggering restart for %s - %d < %s",
                            podName, podAge.seconds, maxAge)

if triggerRestart:
    rollDeployment()
