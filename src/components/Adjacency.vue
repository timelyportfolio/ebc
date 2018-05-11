<template>
  <svg
    :width = "400"
    :height = "400"
  >
    <rect
       v-for="(node, index) in matrix"
        v-bind:index="index"
        v-bind:key="node.id ? node.id : node.name"
        :width = "node.width"
        :height = "node.height"
        :x = "node.x"
        :y = "node.y"
        style = "stroke:black; fill:pink;"
      >
      </rect>
  </svg>
</template>

<script>
import {hierarchy} from 'd3-hierarchy'
import adjlayout from '../d3adjacency.js'

export default {
  props: ['hier'],
  computed: {
    layout: function() {
      var hier = this.hier
      var layout = adjlayout()
        .size([400,400])
        .nodes(hier.descendants())
        .links(hier.links())
        .nodeID(d => d.data.name)
      return layout;
    },
    matrix: function() {
      return this.layout()
    }
  }
}
</script>

<style scoped>

</style>
