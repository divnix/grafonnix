{ POP, nixlib }:
{
  /**
   * Creates a [text panel](https://grafana.com/docs/grafana/latest/panels/visualizations/text-panel/).
   *
   * @name text.new
   *
   * @param title (default `""`) Panel title.
   * @param description (optional) Panel description.
   * @param datasource (optional) Panel datasource.
   * @param span (optional)
   * @param content (default `""`)
   * @param mode (default `"markdown"`) Rendering of the content: "markdown","html", ...
   * @param transparent (optional) Whether to display the panel without a background.
   * @param repeat (optional) Name of variable that should be used to repeat this panel.
   * @param repeatDirection (default `"h"`) "h" for horizontal or "v" for vertical.
   * @param repeatMaxPerRow (optional) Maximum panels per row in repeat mode.
   */
  new = {
    title?"",
    span?null,
    mode?"markdown",
    content?"",
    transparent?null,
    description?null,
    datasource?null,
    repeat?null,
    repeatDirection?null,
    repeatMaxPerRow?null,
  }: POP.lib.kPop
    (nixlib.lib.optionalAttrs (transparent != null){
      inherit transparent;
    }) // {
      title=title;
    } // nixlib.lib.optionalAttrs (span!= null) {
      span = span;
    } // {
      type = "text";
    } // {
      mode= mode;
      content= content;
    } // nixlib.lib.optionalAttrs (description != null) {
      description = description;
    } // {
      datasource= datasource;
      } // nixlib.lib.optionalAttrs (repeat != null) {
     repeat=repeat;
      } // nixlib.lib.optionalAttrs (repeat != null) {
     repeatDirection=repeatDirection;
      } // nixlib.lib.optionalAttrs (repeat != null) {
     repeatMaxPerRow=repeatMaxPerRow;
    };
}
