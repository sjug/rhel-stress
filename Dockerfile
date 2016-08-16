FROM registry.access.redhat.com/rhel7.2

# Docker Token
ARG docker_token

# Setup repos
RUN curl -H "Authorization: token ${docker_token}" -H 'Accept: application/vnd.github.v3.raw' -O -Ls https://api.github.com/repos/openshift/aos-ansible/contents/playbooks/roles/ops_mirror_bootstrap/files/client-cert.pem && \
    curl -H "Authorization: token ${docker_token}" -H 'Accept: application/vnd.github.v3.raw' -O -Ls https://api.github.com/repos/openshift/aos-ansible/contents/playbooks/roles/ops_mirror_bootstrap/files/client-key.pem && \
    curl -H "Authorization: token ${docker_token}" -H 'Accept: application/vnd.github.v3.raw' -O -Ls https://api.github.com/repos/openshift/aos-ansible/contents/playbooks/roles/ops_mirror_bootstrap/files/oso-rhui-rhel-server-extras.repo && \
    curl -H "Authorization: token ${docker_token}" -H 'Accept: application/vnd.github.v3.raw' -O -Ls https://api.github.com/repos/openshift/aos-ansible/contents/playbooks/roles/ops_mirror_bootstrap/files/oso-rhui-rhel-server-releases.repo && \
    mv *.pem /var/lib/yum/ && mv *.repo /etc/yum.repos.d/

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
