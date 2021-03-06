#!/bin/bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
# don't check host keys - the tests need to access repos over ssh, which would
# otherwise stall asking about the server's fingerprint
echo -e 'Host bitbucket.org\n\tStrictHostKeyChecking no\n' >> ~/.ssh/config
# We also need an account to access things on bitbucket (our test packages), so
# we have a dummy account with this public private key:
echo -e "-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEA/C5iyF6B2eM0U5vmpw3qu6r1sGrWII5mk9j5dK4xnUWfPqzF\n6TyVs3C69oT6VORI0z5fMpFYET8hNbaEMCg23S9LaYn420lrDmuEmrMmEod34E7w\nHr65tsJHaUtedIoua9vLBzLiq2k31uteF7EMIp8Ln3zlaPpaGj5Y9lj8fGATm9fS\nBvUR0msKKNIO4yU+xqIzPkKDA4h+fuBXL1J/5DUp96A22CD9xN8VfWJSEJXWAKas\nl6EH+5Rbyp8uFcJT3E2LhRnNwEJWkNpDXiOva7m2PsaIdN4x/DLLjG+A6minyVeS\nS2vBOFScChEhGn/x4pAz0kXF+wIYEyIeY76CdQIDAQABAoIBAQDkjhHfcbAUTxSM\ntl5ch4N4JSDZjGqXRRh45QxpkLrMxF3oiuQwWEWBRSld5fWP3PqX4g6boRkFQIcT\nzGCP2NKosoWRmIegDzFk91NOdhGKd5bRCBoec1OT7Q6VwsZPrzEVdjXTR24iVpFS\nSy2TIVZTRnxdRvAQrd3drSYp10q2WPy4vvzxo7TLCg29888n8YIGb6ttvW3ytyB2\nuhjGk7uCNpTDDPNLhJAXTiX2JeBq6WYHM4YbRZe0tCE/3hEQG7nM0Kx8H+Km3sN1\ngSTEoMGnnFDjIEGarj0rZYB6b8SxvEZ52m2PteeI9myn5StLYBLVpZ/CMTbmqby4\nVCFcPtghAoGBAP/6ChGcnRqSzYWiBRA23xq7oQ/sIfLsZ/J8n7JL3RgDv+3SQSzE\n63E/QySra8hA2UoPGhjaV4ljrD39Ls2x8mEM9JzSpcEfu+iVzpUGunruK3NsmqTO\nXNAaynx1DyCgaW7syan/c3Z5mpynVPJmKbBaqE7MSU+Xz0sO72XO7YAZAoGBAPw0\nQhaGsR7H3yn5TCA6Ky18hIusHa0vuDXIr5xs1BdlkA91FeoqjXqBuqgjwReUo4pX\nit+TDPGT/43mnLn+YLZpbnfVPNJ6Uu66Lp7xX8pzTE66QTY/RxcqCmqh4qLaw9wd\nTtMhPRzaWFf69K5hiUohaH5+d7BRiIvZZFxEvHC9AoGADWKi0ibxZClXC+zb/OwR\noJE9K9r6L3zDNr/jjew/pHjVuXbsJ44ojaR0O1+nZDJX6nJ9t9z7BNkscZVitCjg\n9sg5plWxizbAmbnzsoFGkRUROpjsQT/1RICSJA3u+5LH0KAbL4OHIyPavORXIdHL\nzkf/UxeFod7bXR5r0FQQwUkCgYEAi1Gm7GCteU56Jeq0Nd1MOs1dPvbuUdxZi0R4\nVhX8N4yAPzmzyG6HRxRg8z8FDKyshuCDM6w86zqRYmbxTwGJlVq6jnH6Ll8qbvvk\ngyLdgq2ciqTzHy9naxFrPap90u68YVzDTXhAFS88vCVCgw4YVB4OZkogfgMcRfzq\nJtpFqpUCgYAzDOOkSQcSEAdPvXq177NEvsHNzA26nH0vl2MXP/uiipPuiSFQeyow\nM0gvDmv7gC3RgNbRX5BWxlYRvIZea+0ayQkfxK3UtLl5IURdOAYxzbY6mehKiU14\n6EyxPyd6iS27FznGuioy9YNTXkPMQNgf77x2muF5DryAL43EiMgFSA==\n-----END RSA PRIVATE KEY-----\n\n" > ~/.ssh/id_rsa
echo -e "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD8LmLIXoHZ4zRTm+anDeq7qvWwatYgjmaT2Pl0rjGdRZ8+rMXpPJWzcLr2hPpU5EjTPl8ykVgRPyE1toQwKDbdL0tpifjbSWsOa4SasyYSh3fgTvAevrm2wkdpS150ii5r28sHMuKraTfW614XsQwinwuffOVo+loaPlj2WPx8YBOb19IG9RHSawoo0g7jJT7GojM+QoMDiH5+4FcvUn/kNSn3oDbYIP3E3xV9YlIQldYApqyXoQf7lFvKny4VwlPcTYuFGc3AQlaQ2kNeI69rubY+xoh03jH8MsuMb4DqaKfJV5JLa8E4VJwKESEaf/HikDPSRcX7AhgTIh5jvoJ1 yottatest@yottabuild.org" > ~/.ssh/id_rsa.pub
# make sure the keys have the right permissions
chmod 600 ~/.ssh/*
# need to be authed to pull from the registry, so stick a set of keys authed to
# the "yottatest" mbed user in ~/.yotta/config.json:
mkdir -p ~/.yotta
chmod 700 ~/.yotta
cp ./.yotta_test_config.json ~/.yotta/config.json

# set git settings
git config --global user.email "test@yottabuild.org"
git config --global user.name "Yotta Travis-CI Bot"

