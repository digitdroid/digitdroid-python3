#!/usr/bin/env python
import sys
import os

C_YELLOW = '\x1b[1;33m'
C_RESET = '\x1b[0m'

if __name__ == "__main__":
    # we should insert app root here
    sys.path.insert(0, os.path.join('/', "app"))
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "app.settings")

    import django

    django.setup()

    from django.conf import settings
    from django.contrib.auth import get_user_model
    from django.db import transaction, IntegrityError

    User = get_user_model()

    try:
        with transaction.atomic():
            # check for the case when we run with persistent database
            if User.objects.count() == 0:
                sys.stdout.write('%s==> Superuser account creation started%s\n' % (C_YELLOW, C_RESET))
                admins = [('admin', 'admin@localhost')] if not len(settings.ADMINS) else settings.ADMINS
                for user in admins:
                    # use first_name_last_name for username if both defined
                    username = user[0].replace(' ', '_')
                    email = user[1]
                    password = 'admin'
                    User.objects.create_superuser(email=email, username=username, password=password)
                    sys.stdout.write('==> Superuser %s (%s) created\n' % (username, email))
            else:
                sys.stdout.write('==> Superuser account can be created only if no Users exist!\n')
            sys.stdout.write('%s==> Superuser account creation completed%s\n' % (C_YELLOW, C_RESET))
    except IntegrityError as e:
        exit(str(e))
