FROM registry.access.redhat.com/rhel7.2

# Docker Token
ENV docker_token

# Setup repos
RUN curl -o /etc/yum.repos.d/oso-rhui-rhel-server-releases.repo https://raw.githubusercontent.com/openshift/aos-ansible/master/playbooks/roles/ops_mirror_bootstrap/files/oso-rhui-rhel-server-releases.repo?token=${docker_token} && \
    curl -o /etc/yum.repos.d/oso-rhui-rhel-server-extras.repo https://raw.githubusercontent.com/openshift/aos-ansible/master/playbooks/roles/ops_mirror_bootstrap/files/oso-rhui-rhel-server-extras.repo?token=${docker_token} && \
    curl -o /var/lib/yum/client-cert.pem https://raw.githubusercontent.com/openshift/aos-ansible/master/playbooks/roles/ops_mirror_bootstrap/files/client-cert.pem?token=${docker_token} && \
    curl -o /var/lib/yum/client-key.pem https://raw.githubusercontent.com/openshift/aos-ansible/master/playbooks/roles/ops_mirror_bootstrap/files/client-key.pem?token=${docker_token}

# Install required packages 
RUN yum install -y bc java-1.8.0-openjdk-headless tar && yum clean all

# Setup jmeter
RUN mkdir -p /opt/jmeter && \
    curl -Ls http://mirrors.gigenet.com/apache//jmeter/binaries/apache-jmeter-3.0.tgz \
	| tar xz --strip=1 -C /opt/jmeter && \
	ln -s /opt/jmeter/bin/jmeter.sh /usr/bin/jmeter

# Copy entrypoint script
COPY docker-entrypoint.sh test.jmx /

ENTRYPOINT ["/docker-entrypoint.sh"]
