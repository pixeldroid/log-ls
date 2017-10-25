package
{
    import system.CommandLine;
    import system.application.ConsoleApplication;

    import pixeldroid.util.log.Log;
    import pixeldroid.util.log.printers.ConsolePrinter;
    import pixeldroid.util.log.printers.FilePrinter;
    import pixeldroid.util.log.LogLevel;
    import pixeldroid.util.log.printers.MultiPrinter;
    import pixeldroid.util.log.Printer;


    public class LogDemoCLI extends ConsoleApplication
    {
        private const logname:String = LogDemoCLI.getFullTypeName();

        override public function run():void
        {
            var fp:FilePrinter = new FilePrinter();
            var mp:MultiPrinter = new MultiPrinter();

            mp.add((new ConsolePrinter()));
            mp.add(fp as Printer);

            Log.printer = mp;
            Log.level = LogLevel.DEBUG;

            Log.info(logname, function():String { return 'logging to console and to file at: ' +fp.logfile; });

            var arg:String;
            for (var i = 0; i < CommandLine.getArgCount(); i++)
            {
                Log.debug(logname, function():String { return ['arg', i, ':', CommandLine.getArg(i)].join(' '); });
            }
        }
    }
}
