<template>
  <Vega v-if="spec !== null" :spec="spec"></Vega>
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
     }
  },
  computed: {
    specvl: function() {
      if(this.matrix.length > 0) {
        return {
          "$schema": "https://vega.github.io/schema/vega-lite/v2.json",
          "data": {"values": this.matrix.slice(0,10)},
          "mark": "bar",
          "encoding": {
            "y": {
              "field": this.y,
              "type": "nominal",
              "sort": this.x
            },
            "x": {
              "field": this.x,
              "type": "quantitative",
              "axis": {
                "title": null
              }
            },
            "tooltip": [
              {"field": this.y, "type": "ordinal"},
              {"field": this.x, "type": "quantitative"}
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
        spec.axes[2].encode = {labels: {interactive: true}};
        spec.axes[2].encode.labels.update = {"tooltip": {"signal": "datum.label"}};
        return spec;
      }
      return null
    }
  }
}
</script>
