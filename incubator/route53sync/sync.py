#!/usr/bin/env python

import boto3
import json
import sys
import os
import logging
from botocore.exceptions import ClientError

# Setup route53 client
route53 = boto3.client('route53')

# Configure Logging
formatter = logging.Formatter('%(asctime)s  %(levelname)8s  %(message)s')
logger = logging.getLogger(__name__)
sh = logging.StreamHandler()
sh.setFormatter(formatter)

logger.setLevel(os.environ.get("LOG_LEVEL", "INFO").upper())
logger.addHandler(sh)

# Helper functions
def is_zone_tagged(zoneId):
    """
    Checks for a Tag and returns True/False
    Takes zoneId as input
    Requires ENV ROUTE53_DEST_TAG
    """
    tags = route53.list_tags_for_resource(
        ResourceType = 'hostedzone',
        ResourceId = zoneId
    )

    requiredTag = os.environ.get("ROUTE53_DEST_TAG").split(":")
    tagExists = False
    for tag in tags['ResourceTagSet']['Tags']:
        logger.debug("Found tag: {}".format(tag))
        if tag['Key'] == requiredTag[0]:
            if tag['Value'] == requiredTag[1]:
                logger.info("Found required tag: {}".format(tag))
                tagExists = True

    return tagExists


def get_records(zoneId):
    """
    Gets all the A and CNAME records from a zone.  Returns a list of dicts
    """
    try:
        records = route53.list_resource_record_sets(HostedZoneId=zoneId)
    except ClientError as e:
        if e.response['Error']['Code'] == "NoSuchHostedZone":
            logger.error("The hosted zone(s) you specified do not exist. Exiting...")
        else:
            logger.error(e)
        sys.exit(1)

    records_list = []
    for index, record in enumerate(records['ResourceRecordSets']):
        if record['Type'] == 'A' or record['Type'] == 'CNAME':
            records_list.append(record)

    return records_list

logger.debug("Getting ZONES from ENV")

# Configure ZONE Ids from ENV
try:
    SOURCE_ZONE_ID = os.environ['ROUTE53_SOURCE_ZONE_ID']
    DEST_ZONE_ID = os.environ['ROUTE53_DEST_ZONE_ID']
except KeyError as e:
    logger.error("You need to configure the environment variables:")
    logger.error(e)
    sys.exit(1)
except:
    logger.error("Unexpected error:", sys.exc_info()[0])
    sys.exit(1)

# Make sure we have zone ids
if not SOURCE_ZONE_ID or not DEST_ZONE_ID:
    logger.error("Your config is incorrect.  Exiting.")
    sys.exit(1)

# Check the zone tags
if os.environ.get("ROUTE53_CHECK_DEST_TAG") in ['True', 'true']:
    logger.info("Checking tags on destination zone")
    if is_zone_tagged(DEST_ZONE_ID) is False:
        logger.error("The required tags are not present. Exiting")
        sys.exit(1)

#Make sure the zones are not the same zone
if SOURCE_ZONE_ID == DEST_ZONE_ID:
    logger.error("The two zone IDs are the same. Exiting.")
    sys.exit(1)

logger.info("Starting sync from {} to {}".format(SOURCE_ZONE_ID, DEST_ZONE_ID))

changes = []
for recordset in get_records(SOURCE_ZONE_ID):
    changerecord = {}
    changerecord['Action'] = 'UPSERT'
    changerecord['ResourceRecordSet'] = recordset
    changes.append(changerecord)

changeBatch = {}
changeBatch['Comment'] = 'Updating zone {} from zone {}'.format(DEST_ZONE_ID, SOURCE_ZONE_ID)
changeBatch['Changes'] = changes

logger.debug("Changeset: {}".format(changes))

response = route53.change_resource_record_sets(
    HostedZoneId = DEST_ZONE_ID,
    ChangeBatch = changeBatch
)

logger.debug("Response: {}".format(response))

changeId = response['ChangeInfo']['Id']

waiter = route53.get_waiter('resource_record_sets_changed')

logger.info("Waiting for {} to be applied.  This could take up to a minute".format(changeId))
waiter.wait(Id=changeId, WaiterConfig={'Delay': 2, 'MaxAttemps': 30})
logger.info("Finished syncing ID: {}".format(changeId))
