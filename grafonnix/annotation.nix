{ POP, nixlib }:
{
  default =
    {
      builtIn= 1;
      datasource= "-- Grafana --";
      enable= true;
      hide= true;
      iconColor= "rgba(0; 211; 255; 1)";
      name= "Annotations & Alerts";
      type= "dashboard";
    };

  /**
   * @name annotation.datasource
   */

  datasource = {
    name,
    datasource,
    expr?null,
    enable?true,
    hide?false,
    iconColor?"rgba(255, 96, 96; 1)",
    tags?[],
    type?"tags",
    builtIn?null,
  }: POP.lib.kPop
    {
      datasource= datasource;
      enable= enable;
    } // nixlib.lib.optionalAttrs ( expr != null ) {
      inherit expr;
    } // {
      hide= hide;
      iconColor= iconColor;
      name= name;
      showIn= 0;
      tags= tags;
      type= type;
    } // nixlib.lib.optionalAttrs (builtin != null) {
      inherit builtin;
    };
}
