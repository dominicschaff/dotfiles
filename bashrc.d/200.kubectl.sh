#!/usr/bin/env bash

if ! hash kubectl 2>/dev/null; then
  return
fi

get_all_resources_for_namespace()
{
  kubectl api-resources --verbs=list --namespaced -o name | while read resource_type; do
    echo "$resource_type";
    kubectl get -n $1 $resource_type
    line
  done
}
