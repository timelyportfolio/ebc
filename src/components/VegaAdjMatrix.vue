<template>
  <Vega v-if="spec !== null" :spec="spec"></Vega>
</template>

<script>
import Vega from './Vega.vue'

export default {
  components: {
    Vega
  },
  props: {
    network: {
      type: Object,
      default: () => {return null}
    }
  },
  computed: {
    spec: function() {
      if(this.network) {
        return {
          "$schema": "https://vega.github.io/schema/vega/v3.0.json",
          "width": 770,
          "height": 770,
          "padding": 2,

          "signals": [
            { "name": "cellSize", "value": 10 },
            { "name": "width", "update": "span(range('position'))" },
            { "name": "height", "update": "width" },
            {
              "name": "src", "value": {},
              "on": [
                {"events": "text:mousedown", "update": "datum"},
                {"events": "window:mouseup", "update": "{}"}
              ]
            },
            {
              "name": "dest", "value": {},
              "on": [
                {
                  "events": "[text:mousedown, window:mouseup] > text:mouseover",
                  "update": "src.name != null ? datum : dest"
                },
                {"events": "text:mouseout", "update": "{}"}
              ]
            },
            {"name": "destOrder", "update": "dest.order"},
            {"name": "dragging",  "update": "src.name && dest.name"}
          ],

          "data": [
            {
              "name": "nodes",
              "values": this.network.nodes,
              "transform": [
                { "type": "collect", "sort": {"field": "ArticleCount", "order": "descending"} },
                { "type": "window", "ops": ["rank"], "as": ["order"] },
                {
                  "type": "formula", "as": "order",
                  "expr": "dragging && datum === dest ? src.order : datum.order"
                },
                {
                  "type": "formula", "as": "order",
                  "expr": "dragging && datum === src ? destOrder : datum.order"
                }
              ]
            },
            {
              "name": "edges",
              "values": this.network.links,
              "transform": [
                {
                  "type": "lookup", "from": "nodes", "key": "name",
                  "fields": ["source", "target"], "as": ["sourceNode", "targetNode"]
                }
              ]
            },
            {
              "name": "cross",
              "source": "nodes",
              "transform": [
                { "type": "cross" }
              ]
            }
          ],

          "scales": [
            {
              "name": "position",
              "type": "band",
              "domain": {"data": "nodes", "field": "order", "sort": true},
              "range": {"step": {"signal": "cellSize"}}
            },
            {
              "name": "color",
              "type": "sequential",
              "range": "heatmap",
              "domain": {"data": "edges", "field": "ArticleCount"}
            },
            {
              "name": "labels",
              "type": "ordinal",
              "domain": {"data": "nodes", "field": "order"},
              "range": {"data": "nodes", "field": "name"}
            }
          ],

          "marks": [
            {
              "type": "rect",
              "from": {"data": "cross"},
              "encode": {
                "update": {
                  "x": {"scale": "position", "field": "a.order"},
                  "y": {"scale": "position", "field": "b.order"},
                  "width": {"scale": "position", "band": 1, "offset": -1},
                  "height": {"scale": "position", "band": 1, "offset": -1},
                  "fill": [
                    {"test": "datum.a === src || datum.b === src", "value": "#ddd"},
                    {"value": "#f5f5f5"}
                  ]
                }
              }
            },
            {
              "type": "rect",
              "from": {"data": "edges"},
              "encode": {
                "update": {
                  "x": {"scale": "position", "field": "sourceNode.order"},
                  "y": {"scale": "position", "field": "targetNode.order"},
                  "width": {"scale": "position", "band": 1, "offset": -1},
                  "height": {"scale": "position", "band": 1, "offset": -1},
                  "fill": {"scale": "color", "field": "ArticleCount"}
                }
              }
            },
            {
              "type": "rect",
              "from": {"data": "edges"},
              "encode": {
                "update": {
                  "x": {"scale": "position", "field": "targetNode.order"},
                  "width": {"scale": "position", "band": 1, "offset": -1},
                  "y": {"scale": "position", "field": "sourceNode.order"},
                  "height": {"scale": "position", "band": 1, "offset": -1},
                  "fill": {"scale": "color", "field": "ArticleCount"}
                }
              }
            },
            {
              "type": "text",
              "from": {"data": "nodes"},
              "encode": {
                "update": {
                  "x": {"scale": "position", "field": "order"},
                  "y": {"offset": -2},
                  "dy": {"scale": "position", "band": 0.5},
                  "text": {"field": "name"},
                  "fontSize": {"value": 10},
                  "angle": {"value": -90},
                  "align": {"value": "left"},
                  "baseline": {"value": "middle"},
                  "fill": [
                    {"test": "datum === src", "value": "steelblue"},
                    {"value": "black"}
                  ]
                }
              }
            },
            {
              "type": "text",
              "from": {"data": "nodes"},
              "encode": {
                "update": {
                  "x": {"offset": -2},
                  "y": {"scale": "position", "field": "order"},
                  "dy": {"scale": "position", "band": 0.5},
                  "text": {"field": "name"},
                  "fontSize": {"value": 10},
                  "align": {"value": "right"},
                  "baseline": {"value": "middle"},
                  "fill": [
                    {"test": "datum === src", "value": "steelblue"},
                    {"value": "black"}
                  ]
                }
              }
            }
          ]
        }
      }


      return null;
    }
  }
}
</script>
