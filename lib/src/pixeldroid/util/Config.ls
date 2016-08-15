package pixeldroid.util
{
    import pixeldroid.util.LogLevel;

    /**
        Provides access to configuration values defined in assets/app.config
    */
    class Config
    {
        private static var _fileContents:String;
        private static var _json:JSON;

        /**
            Retrieve the verbosity level to be used for the logging system.
        */
        public static function get logLevel():LogLevel
        {
            var value:String = json.getString('log_level');

            return LogLevel.fromString(value);
        }

        /**
            Retrieve the raw contents of the app.config file.
        */
        public static function get fileContents():String
        {
            if (!_fileContents)
            {
                var filePath:String = 'assets/app.config';
                if (File.fileExists(filePath)) _fileContents = File.loadTextFile(filePath);
                else Debug.assertException(new Error("no config file found at '" +filePath +"'"));
            }

            return _fileContents;
        }

        public static function refresh():void
        {
            _fileContents = null;
            _json.loadString(fileContents);
        }

        /**
            Retrieve the app version string.
        */
        public static function get appVersion():String
        {
            var value:String = json.getString('app_version');

            return value;
        }

        /**
            Retrieve an arbitrary string value from app.config.
        */
        public static function getString(key:String):String
        {
            var value:String = json.getString(key);

            return value;
        }

        /**
            Retrieve an arbitrary number value from app.config.
            Note: the number must be defined with a decimal point.
        */
        public static function getNumber(key:String):Number
        {
            var value:Number = json.getFloat(key);

            return value;
        }

        /**
            Retrieve an arbitrary integer value from app.config.
        */
        public static function getInteger(key:String):Number
        {
            var value:Number = json.getInteger(key);

            return value;
        }


        private static function get json():JSON
        {
            if (!_json)
            {
                _json = new JSON();
                if (!_json.loadString(fileContents))
                {
                    Debug.assertException(new Error("error parsing json file: '" +_json.getError() +"'"));
                }
            }

            return _json;
        }
    }
}
