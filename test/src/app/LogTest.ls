package
{
    import system.application.ConsoleApplication;

    import pixeldroid.bdd.SpecExecutor;

    import ConfigSpec;
    import LogSpec;


    public class LogTest extends ConsoleApplication
    {
        override public function run():void
        {
            SpecExecutor.parseArgs();

            SpecExecutor.exec([
                ConfigSpec,
                LogSpec
            ]);
        }
    }

}
