---
title:  Debugging Azure Container Instance Startup 
authorId: simon_timms
date: 2022-08-04
originalurl: https://blog.simontimms.com/2022/08/04/debug_azure_container_instances_startup
mode: public
---



I have some container instances which are failing to start up properly and the logs in the portal are blank. This makes debugging them kind of difficult. 

On the command line running 

```bash
az container logs -g <resource group name> -n <container group name> --container <container name>
```

Just gave me an output of `None`. Not useful either.

Fortunately, you can attach directly to the logs streams coming out of the container which will give you a better idea of what is going on.

```bash
az container attach -g <resource group name> -n <container group name> --container <container name>
```

This was able to give me output like 

```
Start streaming logs:
/usr/local/lib/python3.9/site-packages/environ/environ.py:628: UserWarning: /ric-api/core/.env doesn't exist - if you're not configuring your environment separately, create one.
  warnings.warn(
Traceback (most recent call last):
  File "/usr/local/lib/python3.9/site-packages/environ/environ.py", line 273, in get_value
    value = self.ENVIRON[var]
  File "/usr/local/lib/python3.9/os.py", line 679, in __getitem__
    raise KeyError(key) from None
KeyError: 'DB_PORT'

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/ric-api/manage.py", line 22, in <module>
    main()
  File "/ric-api/manage.py", line 18, in main
    execute_from_command_line(sys.argv)
  File "/usr/local/lib/python3.9/site-packages/django/core/management/__init__.py", line 419, in execute_from_command_line
    utility.execute()
  File "/usr/local/lib/python3.9/site-packages/django/core/management/__init__.py", line 413, in execute
    self.fetch_command(subcommand).run_from_argv(self.argv)
  File "/usr/local/lib/python3.9/site-packages/django/core/management/base.py", line 354, in run_from_argv
    self.execute(*args, **cmd_options)
  File "/usr/local/lib/python3.9/site-packages/django/core/management/commands/runserver.py", line 61, in execute
    super().execute(*args, **options)
  File "/usr/local/lib/python3.9/site-packages/django/core/management/base.py", line 398, in execute
    output = self.handle(*args, **options)
  File "/usr/local/lib/python3.9/site-packages/django/core/management/commands/runserver.py", line 68, in handle
    if not settings.DEBUG and not settings.ALLOWED_HOSTS:
  File "/usr/local/lib/python3.9/site-packages/django/conf/__init__.py", line 82, in __getattr__
    self._setup(name)
  File "/usr/local/lib/python3.9/site-packages/django/conf/__init__.py", line 69, in _setup
    self._wrapped = Settings(settings_module)
  File "/usr/local/lib/python3.9/site-packages/django/conf/__init__.py", line 170, in __init__
    mod = importlib.import_module(self.SETTINGS_MODULE)
  File "/usr/local/lib/python3.9/importlib/__init__.py", line 127, in import_module
    return _bootstrap._gcd_import(name[level:], package, level)
  File "<frozen importlib._bootstrap>", line 1030, in _gcd_import
  File "<frozen importlib._bootstrap>", line 1007, in _find_and_load
  File "<frozen importlib._bootstrap>", line 986, in _find_and_load_unlocked
  File "<frozen importlib._bootstrap>", line 680, in _load_unlocked
  File "<frozen importlib._bootstrap_external>", line 850, in exec_module
  File "<frozen importlib._bootstrap>", line 228, in _call_with_frames_removed
  File "/ric-api/core/settings.py", line 114, in <module>
    'PORT': env('DB_PORT'),
  File "/usr/local/lib/python3.9/site-packages/environ/environ.py", line 123, in __call__
    return self.get_value(var, cast=cast, default=default, parse_default=parse_default)
  File "/usr/local/lib/python3.9/site-packages/environ/environ.py", line 277, in get_value
    raise ImproperlyConfigured(error_msg)
django.core.exceptions.ImproperlyConfigured: Set the DB_PORT environment variable
2022-07-14T14:37:17.6003172Z stderr F

Exception in thread Thread-1:
Traceback (most recent call last):
  File "threading.py", line 932, in _bootstrap_inner
  File "threading.py", line 870, in run
  File "D:\a\1\s\build_scripts\windows\artifacts\cli\Lib\site-packages\azure/cli/command_modules/container/custom.py", line 837, in _stream_container_events_and_logs
  File "D:\a\1\s\build_scripts\windows\artifacts\cli\Lib\site-packages\azure/cli/command_modules/container/custom.py", line 791, in _stream_logs
AttributeError: 'NoneType' object has no attribute 'split'
```

Looks like I missed adding a `DB_PORT` to the environmental variables 