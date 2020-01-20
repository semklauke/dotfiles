#!/bin/bash
sudo certbot renew --manual-auth-hook /etc/letsencrypt/renewal-hooks/auth/dns-auth.sh --manual-cleanup-hook /etc/letsencrypt/renewal-hooks/cleanup/dns-cleanup.sh
