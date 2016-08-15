package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.util.Config;

    public static class ConfigSpec
    {
        public static function describe():void
        {
            Config.fileContents; // force instantiation and file load

            var it:Thing = Spec.describe('Config');

            it.should('provide access to the app version', function() {
                it.expects(Config.appVersion).toEqual('0.0.0');
            });

            it.should('provide access to the log level', function() {
                it.expects(Config.logLevel.toString()).toEqual('DEBUG');
            });

            it.should('provide access to string values', function() {
                it.expects(Config.getString('string')).toEqual('string value');
            });

            it.should('provide access to number values', function() {
                it.expects(Config.getNumber('number')).toEqual(123.456);
            });

            it.should('provide access to integer values', function() {
                it.expects(Config.getInteger('integer')).toEqual(789);
            });

        }
    }
}
