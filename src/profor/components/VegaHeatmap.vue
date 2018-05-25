<template>
  <Vega v-if="spec !== null" :spec="spec" :use-viewbox="false"></Vega>
</template>

<script>
import * as vl from 'vega-lite'
import Vega from './Vega.vue'

export default {
  components: {
    Vega
  },
  props: {
    matrix: {
      type: Array,
      default: () => {return []}
    },
    x: {
      type: String,
      default: 'x'
    },
    y: {
      type: String,
      default: 'y'
    },
    z: {
      type: String,
      default: 'z'
    }
  },
  computed: {
    specvl: function() {
      if(this.matrix.length > 0) {
        return {
          "$schema": "https://vega.github.io/schema/vega-lite/v2.json",
          "data": {"values": this.matrix},
          "mark": "rect",
          "encoding": {
            "x": {"field": this.x, "type": "ordinal"},
            "y": {"field": this.y, "type": "ordinal"},
            "color": {
              "field": this.z,
              "type": "quantitative",
              "legend": {"orient": "top"},
              "scale": {"scheme":"bluegreen"},
              "zero": true
            },
            "tooltip": [
              {"field": this.x, "type": "ordinal"},
              {"field": this.y, "type": "ordinal"},
              {"field": this.z, "type": "quantitative"}
            ]
          },
          "config": {
            "axis": {
              "labelFont": "inherit",
              "titleFont": "inherit",
              "titlePadding": 60
            },
            "legend": {
              "labelFont": "inherit",
              "titleFont": "inherit"
            }
          }
        }
      }

      return null;
    },
    spec: function() {
      if(this.specvl) {
        var spec = vl.compile(this.specvl).spec;
        spec.axes[0].encode.labels.interactive = true;
        spec.axes[0].encode.labels.update.tooltip = {"signal": "datum.label"};
        spec.axes[1].encode = {labels: {interactive: true}};
        spec.axes[1].encode.labels.update = {"tooltip": {"signal": "datum.label"}};
        return spec;
      }
      return null
    }
  }
}
</script>
