---
layout: page
title: Home
this: "**log-ls**"
---

# {{ page.title }}

{{ page.this }} provides two utilities: **[Log][log]** for sending messages to a [printer][printer] and **[Config][config]** for loading data from a json file.
{:.ui.large.message}

{{ page.this }} provides a simple logging interface that makes it easy to record formatted log messages to one or more log printer:

```as3
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

Log messages are wrapped in a function closure to delay their execution until actually required.

```as3
Log.info('MyLogger', function():String { return 'message to log only if log level is INFO'; });
```

The [default printer][printer-console] logs messages to the console.

A [file printer][printer-file] is also provided.

The [multi-printer][printer-multi] can tee log messages to multiple targets.

Custom printers can be written against the [`Printer`][printer] api.


[config]: api/pixeldroid/util/config/Config/#/api/ "Provides access to configuration values defined in assets/app.config"
[log]: api/pixeldroid/util/log/Log/#/api/ "Provides methods for sending formatted log messages at various verbosity levels"
[printer]: api/pixeldroid/util/log/Printer/#/api/ "Declares a receiver function for use by Log"
[printer-console]: api/pixeldroid/util/log/printers/ConsolePrinter/#/api/ "Provides a console logger"
[printer-file]: api/pixeldroid/util/log/printers/FilePrinter/#/api/ "Provides a file logger"
[printer-multi]: api/pixeldroid/util/log/printers/MultiPrinter/#/api/ "Provides a one-to-many facade for logging a single message to multiple printers"
