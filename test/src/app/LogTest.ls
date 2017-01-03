package
{
    import system.application.ConsoleApplication;

    import pixeldroid.bdd.SpecExecutor;

    import BasicFormatterSpec;
    import ConfigSpec;
    import FilePrinterSpec;
    import LogSpec;
    import MultiPrinterSpec;


    public class LogTest extends ConsoleApplication
    {
        override public function run():void
        {
            SpecExecutor.parseArgs();

            SpecExecutor.exec([
                BasicFormatterSpec,
                ConfigSpec,
                FilePrinterSpec,
                LogSpec,
                MultiPrinterSpec
            ]);
        }
    }

}
