if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
  exec sway 2> /tmp/.sway-logs
fi

# Allow Gatekeeper to send emails from your development
export CF_EMAIL="azer@contentful.com"
# Private registry, which hosts all our images
export DOCKER_REGISTRY=806120774687.dkr.ecr.us-east-1.amazonaws.com
# Specify your default AWS Profile to allow easy login to Docker repo
export AWS_PROFILE=production
