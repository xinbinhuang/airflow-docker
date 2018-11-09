#!/usr/bin/env python3

from cryptography.fernet import Fernet


FERNET_KEY = Fernet.generate_key().decode()
print(FERNET_KEY)
