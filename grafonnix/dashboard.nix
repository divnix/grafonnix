{lib}: let
  timepickerlib = import ./timepicker.nix {inherit lib;};
in {
  /*
    *
   * Creates a [dashboard](https://grafana.com/docs/grafana/latest/features/dashboard/dashboards/)
   *
   * @name dashboard.new
   *
   * @param title The title of the dashboard
   * @param editable (default: `false`) Whether the dashboard is editable via Grafana UI.
   * @param style (default: `"dark"`) Theme of dashboard, `"dark"` or `"light"`
   * @param tags (optional) Array of tags associated to the dashboard, e.g.`["tag1","tag2"]`
   * @param time_from (default: `"now-6h"`)
   * @param time_to (default: `"now"`)
   * @param timezone (default: `"browser"`) Timezone of the dashboard, `"utc"` or `"browser"`
   * @param refresh (default: `""`) Auto-refresh interval, e.g. `"30s"`
   * @param timepicker (optional) See timepicker API
   * @param graphTooltip (default: `"default"`) `"default"` : no shared crosshair or tooltip (0), `"shared_crosshair"`: shared crosshair (1), `"shared_tooltip"`: shared crosshair AND shared tooltip (2)
   * @param hideControls (default: `false`)
   * @param schemaVersion (default: `14`) Version of the Grafana JSON schema, incremented each time an update brings changes. `26` for Grafana 7.1.5, `22` for Grafana 6.7.4, `16` for Grafana 5.4.5, `14` for Grafana 4.6.3. etc.
   * @param uid (default: `""`) Unique dashboard identifier as a string (8-40), that can be chosen by users. Used to identify a dashboard to update when using Grafana REST API.
   * @param description (optional)
   *
   * @method addTemplate(template) Add a template variable
   * @method addTemplates(templates) Adds an array of template variables
   * @method addAnnotation(annotation) Add an [annotation](https://grafana.com/docs/grafana/latest/dashboards/annotations/)
   * @method addPanel(panel,gridPos) Appends a panel, with an optional grid position in grid coordinates, e.g. `gridPos={"x":0, "y":0, "w":12, "h": 9}`
   * @method addPanels(panels) Appends an array of panels
   * @method addLink(link) Adds a [dashboard link](https://grafana.com/docs/grafana/latest/linking/dashboard-links/)
   * @method addLinks(dashboardLink) Adds an array of [dashboard links](https://grafana.com/docs/grafana/latest/linking/dashboard-links/)
   * @method addRequired(type, name, id, version)
   * @method addInput(name, label, type, pluginId, pluginName, description, value)
   * @method addRow(row) Adds a row. This is the legacy row concept from Grafana < 5, when rows were needed for layout. Rows should now be added via `addPanel`.
   */
  new = {
    title,
    editable ? false,
    style ? "dark",
    tags ? [],
    time_from ? "now-6h",
    time_to ? "now",
    timezone ? "browser",
    refresh ? "",
    timepicker ? timepickerlib.new {},
    graphTooltip ? "default",
    hideControls ? false,
    schemaVersion ? 14,
    uid ? "",
    description ? null,
  }:
    lib.pop {
      extension = self: super: let
        it = self;
      in
        {
          _annotations = [];
        }
        // lib.optionalAttrs (uid != "") {
          uid = uid;
        }
        // {
          editable = editable;
        }
        // lib.optionalAttrs (description != null) {
          description = description;
        }
        // {
          gnetId = null;
          graphTooltip =
            if graphTooltip == "shared_tooltip"
            then 2
            else if graphTooltip == "shared_crosshair"
            then 1
            else if graphTooltip == "default"
            then 0
            else graphTooltip;
          hideControls = hideControls;
          id = null;
          links = [];
          panels = [];
          refresh = refresh;
          rows = [];
          schemaVersion = schemaVersion;
          style = style;
          tags = tags;
          time = {
            from = time_from;
            to = time_to;
          };
          timezone = timezone;
          timepicker = timepicker;
          title = title;
          version = 0;
          addAnnotations = annotations:
            self (self: super: {
              _annotations = super._annotations ++ annotations;
            });
          addAnnotation = a: self.addAnnotations [a];
          addTemplates = templates:
            self (self: super: {
              templates = super.templates ++ templates;
            });
          addTemplate = t: self.addTemplates [t];
          templates = [];
          annotations = {list = it._annotations;};
          templating = {list = it.templates;};
          _nextPanel = 2;
          addRow = row:
            self (self: super: let
              # automatically number panels in added rows.
              # https://github.com/kausalco/public/blob/master/klumps/grafana.libsonnet
              n = lib.length row.panels;
              nextPanel = super._nextPanel;
              panels = lib.genList (i:
                (lib.elemAt row.panels i) {id = nextPanel + i;})
              n;
            in {
              _nextPanel = nextPanel + n;
              rows = super.rows ++ [row {panels = panels;}];
            });
          addPanels = newpanels:
            self (self: super: let
              # automatically number panels in added rows.
              # https://github.com/kausalco/public/blob/master/klumps/grafana.libsonnet
              n =
                lib.foldl (numOfPanels: p:
                  if lib.elem "panels" p
                  then numOfPanels + 1 + (lib.length p.panels)
                  else numOfPanels + 1)
                0
                newpanels;
              nextPanel = super._nextPanel;
              _panels =
                lib.genList
                (
                  i:
                    (lib.elemAt newpanels i) {
                      id =
                        nextPanel
                        + (
                          if i == 0
                          then 0
                          else if lib.elem "panels" (lib.elemAt _panels (i - 1))
                          then ((lib.elemAt _panels (i - 1)).id - nextPanel) + 1 + (lib.length (lib.elemAt _panels (i - 1)).panels)
                          else ((lib.elemAt _panels (i - 1)).id - nextPanel) + 1
                        );
                    }
                    // lib.optionalAttrs (lib.elem "panels" (lib.elemAt newpanels i)) {
                      panels = lib.genList (
                        j:
                          (lib.elemAt (lib.elemAt newpanels i).panels j) {
                            id =
                              1
                              + j
                              + nextPanel
                              + (
                                if i == 0
                                then 0
                                else if lib.elem "panels" (lib.elemAt _panels (i - 1))
                                then ((lib.elemAt _panels (i - 1)).id - nextPanel) + 1 + (lib.length (lib.elemAt _panels (i - 1)).panels)
                                else ((lib.elemAt _panels (i - 1)).id - nextPanel) + 1
                              );
                          }
                      ) (lib.length ((lib.elemAt newpanels i).panels));
                    }
                ) (lib.length newpanels);
            in {
              _nextPanel = nextPanel + n;
              panels = super.panels ++ _panels;
            });
          addPanel = {
            panel,
            gridPos,
          }:
            self.addPanels [(panel {gridPos = gridPos;})];
          addRows = rows: lib.foldl (d: row: d.addRow row) self rows;
          addLink = link:
            self (self: super: {
              links = super.links ++ [link];
            });
          addLinks = dashboardLinks: lib.foldl (d: t: d.addLink t) self dashboardLinks;
          required = [];
          __requires = it.required;
          addRequired = {
            type,
            name,
            id,
            version,
          }:
            self (self: super: {
              required =
                super.required
                ++ [
                  {
                    type = type;
                    name = name;
                    id = id;
                    version = version;
                  }
                ];
            });
          inputs = [];
          __inputs = it.inputs;
          addInput = {
            name,
            label,
            type,
            pluginId ? null,
            pluginName ? null,
            description ? "",
            value ? null,
          }:
            self (self: super: {
              inputs =
                super.inputs
                ++ [
                  ({
                      name = name;
                      label = label;
                      type = type;
                    }
                    // lib.optionalAttrs (pluginId != null) {
                      pluginId = pluginId;
                    }
                    // lib.optionalAttrs (pluginName != null) {
                      pluginName = pluginName;
                    }
                    // lib.optionalAttrs (value != null) {
                      value = value;
                    }
                    // {
                      description = description;
                    })
                ];
            });
        };
    };
}
