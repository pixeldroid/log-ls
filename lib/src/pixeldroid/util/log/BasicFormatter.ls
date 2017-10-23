package pixeldroid.util.log
{
    import pixeldroid.util.Log;
    import pixeldroid.util.log.Formatter;

    /**
        Provides a basic message formatting function for use by `Log`.

        Log messages are prepended with a timestamp, level, and label:

        ```
        00:00:00.024 [ INFO] .LogDemoCLI: log test!
        00:00:00.025 [DEBUG] .LogDemoCLI: debug statement
        ```

        @see pixeldroid.util.Log#formatter
    */
    class BasicFormatter implements Formatter
    {
        /** @copy pixeldroid.util.log.Formatter */
        public function format(time:Number, level:LogLevel, label:String, message:String):String
        {
            var h:Number = Math.floor(time / (60 * 60 * 1000));
            time -= h * (60 * 60 * 1000);
            var m:Number = Math.floor(time / (60 * 1000));
            time -= m * (60 * 1000);
            var s:Number = Math.floor(time / 1000);
            time -= s * 1000;
            var l:Number = time;

            var hh:String = String.lpad(h.toString(), '0', 2);
            var mm:String = String.lpad(m.toString(), '0', 2);
            var ss:String = String.lpad(s.toString(), '0', 2);
            var ll:String = String.lpad(l.toString(), '0', 3);

            return hh +':' + mm + ':' + ss + '.' + ll + ' [' + String.lpad(Log.levelToString(level), ' ', 5) + '] ' + label + ': ' + message;
        }
    }
}
