log-ls
======

a simple logging framework for Loom, plus a handy config reader


## installation

Download the library into its matching sdk folder:

    $ curl -L -o ~/.loom/sdks/sprint34/libs/Log.loomlib \
        https://github.com/pixeldroid/spec-ls/releases/download/v1.1.5/Log-sprint34.loomlib

To uninstall, simply delete the file:

    $ rm ~/.loom/sdks/sprint34/libs/Log.loomlib


## usage

### Log

0. import `Log` (once per class)
0. declare a label (once per class)
0. set the log level (once at app startup, ideally from a config file value)
0. submit a message generator at some verbosity level (`debug`, `info`, `warn`, `error`, `fatal`)

```ls
package
{
    import loom.Application;

    import pixeldroid.util.Log;
    import pixeldroid.util.LogLevel;


    public class LogTest extends Application
    {
        private const _logName:String = getFullTypeName();

        override public function run():void
        {
            Log.level = LogLevel.INFO;
            Log.info(_logName, function():String { return _logName +' is running!'; });
        }
    }
}
```

### Config

0. create a json file named `app.config` in the `assets/` folder of the project root
0. import `Config`
0. retrieve values

```json
{
  "app_version": "1.0.0",
  "log_level": "DEBUG",
  "my_string": "string value",
  "my_number": 123.456,
  "my_integer": 789
}
```
> _assets/app.config_

```ls
package
{
    import loom.Application;

    import pixeldroid.util.Config;
    import pixeldroid.util.Log;
    import pixeldroid.util.LogLevel;


    public class ConfigTest extends Application
    {
        private const _logName:String = getFullTypeName();

        override public function run():void
        {
            Log.level = LogLevel.INFO;
            Log.info(_logName, function():String { return 'app version: ' +Config.appVersion; });
            Log.info(_logName, function():String { return 'log level: ' +Config.logLevel; });
            Log.info(_logName, function():String { return 'my string: ' +Config.getString('my_string'); });
            Log.info(_logName, function():String { return 'my number: ' +Config.getNumber('my_number'); });
            Log.info(_logName, function():String { return 'my integer: ' +Config.getInteger('my_integer'); });
        }
    }
}
```

## working from source

first install [loomtasks][loomtasks]

### compiling

    $ rake lib:install

this will build the Log library and install it in the currently configured sdk

### running tests

    $ rake test

this will build the Log library, install it in the currently configured sdk, build the test app, and run the test app.


## contributing

Pull requests are welcome!


[loomtasks]: https://github.com/pixeldroid/loomtasks "loomtasks"
