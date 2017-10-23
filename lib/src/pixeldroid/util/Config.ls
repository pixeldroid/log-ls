package pixeldroid.util
{
    import system.Debug;
    import system.JSON;
    import system.errors.Error;

    import pixeldroid.util.Log;
    import pixeldroid.util.log.LogLevel;

    /**
        Provides access to configuration values defined in `assets/app.config`.

        `app.config` should be a valid JSON file stored under the `assets/` directory.

        A simple example might look like the following:

        ```json
        {
           ⇥"app_version": "1.0.0",
           ⇥"log_level": "DEBUG",
           ⇥"my_string": "string value",
           ⇥"my_number": 123.456,
           ⇥"my_integer": 789
        }
        ```
    */
    class Config
    {
        private static var _fileContents:String;
        private static var _json:JSON;

        /**
            Verbosity level to be used for the logging system.
        */
        public static function get logLevel():LogLevel
        {
            var level:String = json.getString('log_level');

            return Log.levelFromString(level);
        }

        /**
            Raw contents of the `app.config` file.
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

        /**
            Reload the config values from file.
        */
        public static function refresh():void
        {
            _fileContents = null;
            _json.loadString(fileContents);
        }

        /**
            App version string.
        */
        public static function get appVersion():String
        {
            var value:String = json.getString('app_version');

            return value;
        }

        /**
            Retrieve an arbitrary string value from `app.config`.

            @param key The key to retrieve a string value for
            @return The string value for the provided key
        */
        public static function getString(key:String):String
        {
            var value:String = json.getString(key);

            return value;
        }

        /**
            Retrieve an arbitrary number value from `app.config`.
            _Note:_ the number must be defined with a decimal point.

            @param key The key to retrieve a number value for
            @return The number value for the provided key
        */
        public static function getNumber(key:String):Number
        {
            var value:Number = json.getFloat(key);

            return value;
        }

        /**
            Retrieve an arbitrary integer value from `app.config`.

            @param key The key to retrieve an integer value for
            @return The integer value for the provided key
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
