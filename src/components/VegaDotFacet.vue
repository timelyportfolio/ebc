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
          "facet": {
            "column": {
              "field": this.facet,
              "type": "nominal"
            }
          },
          "spec": {
            "mark": "point",
            "encoding": {
              "y": {"field": this.y, "type": "ordinal"},
              "x": {"field": this.x, "type": "quantitative"}
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
