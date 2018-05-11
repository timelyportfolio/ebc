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
