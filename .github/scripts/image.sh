#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

. ./.github/scripts/common.sh

# Building the skupper-router image
${DOCKER} build -t ${PROJECT_NAME}:${PROJECT_TAG} -f ./.github/scripts/Dockerfile .

# Pushing only when credentials available
if [[ -n "${DOCKER_USER}" && -n "${DOCKER_PASSWORD}" ]]; then
    ${DOCKER} login -u ${DOCKER_USER} -p ${DOCKER_PASSWORD} ${DOCKER_REGISTRY}
    ${DOCKER} tag ${PROJECT_NAME}:${PROJECT_TAG} ${DOCKER_REGISTRY}/${DOCKER_ORG}/${PROJECT_NAME}:${PROJECT_TAG}
    ${DOCKER} push ${DOCKER_REGISTRY}/${DOCKER_ORG}/${PROJECT_NAME}:${PROJECT_TAG}
    if ${PUSH_LATEST}; then
        ${DOCKER} tag ${PROJECT_NAME}:${PROJECT_TAG} ${DOCKER_REGISTRY}/${DOCKER_ORG}/${PROJECT_NAME}:latest
        ${DOCKER} push ${DOCKER_REGISTRY}/${DOCKER_ORG}/${PROJECT_NAME}:latest
    fi
fi
