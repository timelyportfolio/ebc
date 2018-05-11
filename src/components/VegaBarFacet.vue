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
     facet: {
       type: [String,Object]
     },
     x: {
       type: String,
       default: 'x',
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
          "facet": {
            "column": {
              "field": this.facet,
              "type": "nominal",
            }
          },
          "spec": {
            "mark": "rect",
            "encoding": {
              "y": {
                "field": this.y,
                "type": "nominal"
              },
              "x": {
                "field": this.x,
                "type": "quantitative",
                "axis": {
                  title: null
                }
              },
              "color": {"field": this.facet, "type": "nominal", "legend": null}
            }
          },
          "config": {
            "axis": {
              "labelFont": "inherit",
              "titleFont": "inherit"
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
        return vl.compile(this.specvl).spec
      }
      return null
    }
  }
}
</script>
