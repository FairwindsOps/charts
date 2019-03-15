package kubernetes.admission

import data.kubernetes.namespaces

deny[msg] {
    input.request.kind.kind = "Deployment"
    input.request.operation = "CREATE"
    image = input.request.object.spec.template.spec.containers[_].image
    not valid_name(image, valid_image_regexes)
    msg = sprintf("invalid image name %q", [image])
}

valid_image_regexes = {regex|
    whitelist = namespaces[input.request.namespace].metadata.annotations["image-whitelist"]
    regexes = split(whitelist, ",")
    regex = regexes[_]
}

valid_name(str, patterns) {
    re_match(patterns[_], str)
}
