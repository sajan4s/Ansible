ARG SRC_REPO_URL=213779334216.dkr.ecr.us-west-2.amazonaws.com/teo-base-ansible
ARG SRC_IMAGE_TAG=latest
FROM ${SRC_REPO_URL}:${SRC_IMAGE_TAG}

# ansible pre-build step input
ARG ansible_setup_file=setup-controller.yml
ARG ansible_requirements_file=requirements.yml.j2

# ansible user data arg/env combos
ARG ansible_data_version=master
ARG ansible_playbooks_version=master
ARG ansible_app_dynamics_version=master
ARG ansible_multi_app_version=master
ARG ansible_patchautomation_version=master
ARG ansible_proxy_common_version=master
ARG ansible_tripcase_platform_version=master
ARG ansible_templates_patchautomation_version=master
ARG ansible_tripcase_touch2_version=master
ARG ansible_tripcase_tcrails_version=master

ENV ansible_data_version=$ansible_data_version \
  ansible_playbooks_version=$ansible_playbooks_version \
  ansible_app_dynamics_version=$ansible_app_dynamics_version \
  ansible_multi_app_version=$ansible_multi_app_version \
  ansible_patchautomation_version=$ansible_patchautomation_version \
  ansible_proxy_common_version=$ansible_proxy_common_version \
  ansible_tripcase_platform_version=$ansible_tripcase_platform_version \
  ansible_templates_patchautomation_version=$ansible_templates_patchautomation_version \
  ansible_tripcase_touch2_version=$ansible_tripcase_touch2_version \
  ansible_tripcase_tcrails_version=$ansible_tripcase_tcrails_version

# ansible system data arg/env combos
ARG ANSIBLE_REMOTE_USER=localansible-eto
ARG ANSIBLE_VAULT_PASSWORD=replaceme

ENV ANSIBLE_REMOTE_USER=$ANSIBLE_REMOTE_USER \
  ANSIBLE_HOST_KEY_CHECKING=False \
  ANSIBLE_INVENTORY=/code/ansible-data/cert/hosts \
  ANSIBLE_ROLES_PATH=/code/ansible-roles:/usr/share/ansible/roles:/etc/ansible/roles \
  ANSIBLE_VAULT_PASSWORD_FILE=/code/.vault_pass.txt

# TODO: perhaps run a command to generate the inventory file
# For now, just checking it out of source code
# locally during the build process and mounting as volume

RUN useradd -s /bin/bash $ANSIBLE_REMOTE_USER \
 && mkdir -p /home/$ANSIBLE_REMOTE_USER/.ssh

COPY known_hosts /home/$ANSIBLE_REMOTE_USER/.ssh/known_hosts
COPY id_rsa /home/$ANSIBLE_REMOTE_USER/.ssh/id_rsa
COPY codecommit_rsa /home/$ANSIBLE_REMOTE_USER/.ssh/codecommit_rsa
COPY ssh_config /home/$ANSIBLE_REMOTE_USER/.ssh/config
COPY $ansible_setup_file /code/setup-controller.yml
COPY $ansible_requirements_file /tmp/requirements.yml.j2
COPY ansible.cfg /etc/ansible/ansible.cfg

RUN chown -R $ANSIBLE_REMOTE_USER:$ANSIBLE_REMOTE_USER /home/$ANSIBLE_REMOTE_USER/.ssh \
 && chmod 0700 /home/$ANSIBLE_REMOTE_USER/.ssh \
 && chmod 0400 /home/$ANSIBLE_REMOTE_USER/.ssh/codecommit_rsa \
 && chmod 0600 /home/$ANSIBLE_REMOTE_USER/.ssh/config

RUN mkdir -p /code \
 && echo $ANSIBLE_VAULT_PASSWORD > /code/.vault_pass.txt \
 && chmod 0400 /code/.vault_pass.txt \
 && chown -R $ANSIBLE_REMOTE_USER:$ANSIBLE_REMOTE_USER /code

USER $ANSIBLE_REMOTE_USER

WORKDIR /code/ansible-controller

RUN ansible-playbook -l localhost /code/setup-controller.yml