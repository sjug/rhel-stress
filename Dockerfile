FROM registry.access.redhat.com/rhel7.2

# Setup repos
RUN curl -o /etc/yum.repos.d/rhel7-latest.repo http://git.app.eng.bos.redhat.com/git/perf-dept.git/plain/repo_files/rhel7-latest.repo

# Install required packages 
RUN yum install -y java-1.8.0-openjdk-headless tar && yum clean all

# Setup jmeter
RUN mkdir -p /opt/jmeter && \
    curl -Ls http://mirrors.gigenet.com/apache//jmeter/binaries/apache-jmeter-3.0.tgz \
	| tar xz --strip=1 -C /opt/jmeter && \
	ln -s /opt/jmeter/bin/jmeter.sh /usr/bin/jmeter

# Copy entrypoint script
COPY docker-entrypoint.sh test.jmx /

ENTRYPOINT ["/docker-entrypoint.sh"]
