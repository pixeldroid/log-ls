package
{
    import system.CommandLine;
    import system.application.ConsoleApplication;

    import pixeldroid.util.Log;
    import pixeldroid.util.log.FilePrinter;
    import pixeldroid.util.log.LogLevel;


    public class LogDemoCLI extends ConsoleApplication
    {
        private const logname:String = LogDemoCLI.getFullTypeName();

        override public function run():void
        {
            var fp:FilePrinter = new FilePrinter();

            Log.level = LogLevel.DEBUG;
            Log.info(logname, function():String { return 'logging to file at: ' +fp.logfile; });

            Log.printer = fp;
            Log.info(logname, function():String { return 'log test!'; });

            var arg:String;
            for (var i = 0; i < CommandLine.getArgCount(); i++)
            {
                Log.debug(logname, function():String { return ['arg', i, ':', CommandLine.getArg(i)].join(' '); });
            }
        }
    }
}
