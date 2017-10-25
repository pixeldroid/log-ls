package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.util.config.Config;
    import pixeldroid.util.log.LogLevel;


    public static class ConfigSpec
    {
        private static var it:Thing;

        public static function specify(specifier:Spec):void
        {
            before();
            it = specifier.describe('Config');

            it.should('provide access to the app version', provide_app_version);
            it.should('provide access to the log level', provide_log_level);
            it.should('provide access to string values', provide_strings);
            it.should('provide access to float values', provide_floats);
            it.should('provide access to integer values', provide_integers);
        }


        private static function before():void
        {
            Config.fileContents; // force instantiation and file load
        }

        private static function provide_app_version():void
        {
            it.expects(Config.appVersion).toEqual('0.0.0');
        }

        private static function provide_log_level():void
        {
            it.expects(Config.logLevel).toEqual(LogLevel.DEBUG);
        }

        private static function provide_strings():void
        {
            it.expects(Config.getString('string')).toEqual('string value');
        }

        private static function provide_floats():void
        {
            it.expects(Config.getNumber('number')).toEqual(123.456);
        }

        private static function provide_integers():void
        {
            it.expects(Config.getInteger('integer')).toEqual(789);
        }
    }
}
