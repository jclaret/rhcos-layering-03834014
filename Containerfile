ARG rhel_coreos_release
FROM ${rhel_coreos_release}

# Set working directory
WORKDIR /rpms

# Copy RPM files from the build context
COPY NM/NetworkManager-1.42.2-30.rmroutes.el9_2.x86_64.rpm \
     NM/NetworkManager-ovs-1.42.2-30.rmroutes.el9_2.x86_64.rpm \
     NM/NetworkManager-cloud-setup-1.42.2-30.rmroutes.el9_2.x86_64.rpm \
     NM/NetworkManager-team-1.42.2-30.rmroutes.el9_2.x86_64.rpm \
     NM/NetworkManager-libnm-1.42.2-30.rmroutes.el9_2.x86_64.rpm \
     NM/NetworkManager-tui-1.42.2-30.rmroutes.el9_2.x86_64.rpm \
     /rpms/

# Install hotfix rpm - https://issues.redhat.com/browse/RHEL-67324
RUN rpm-ostree cliwrap install-to-root / && \ 
    rpm-ostree override replace --cache-only /rpms/NetworkManager-1.42.2-30.rmroutes.el9_2.x86_64.rpm \
                                             /rpms/NetworkManager-ovs-1.42.2-30.rmroutes.el9_2.x86_64.rpm \ 
                                             /rpms/NetworkManager-cloud-setup-1.42.2-30.rmroutes.el9_2.x86_64.rpm \
                                             /rpms/NetworkManager-team-1.42.2-30.rmroutes.el9_2.x86_64.rpm \
                                             /rpms/NetworkManager-libnm-1.42.2-30.rmroutes.el9_2.x86_64.rpm \
                                             /rpms/NetworkManager-tui-1.42.2-30.rmroutes.el9_2.x86_64.rpm && \
    rpm-ostree cleanup -m && \
    ostree container commit
