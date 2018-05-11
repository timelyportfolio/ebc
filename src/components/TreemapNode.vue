<template>
  <g
    v-bind:transform = "'translate(' + node.x0 + ',' + node.y0 +')'"
  >
    <rect
      v-bind="{
        'width': node.x1 - node.x0,
        'height': node.y1 - node.y0,
        'fill': colorScale && colorValueFun ? colorScale(colorValueFun(node)) : 'white'
      }"
      v-bind:style="rectStyle"
    >
    </rect>
    <text
      v-bind:style="textStyle"
      dy = "1em"
      dx = "1px"
    >
      {{textValueFun(node)}}
    </text>
  </g>
</template>

<script>
export default {
  props: {
    node: {
      type: Object
    },
    colorScale: {
      type: [Function,Object],
      default: null
    },
    colorValueFun: {
      type: [Function,Object],
      default: null
    },
    textValueFun: {
      type: [Function,Object],
      default: null
    },
    rectStyle: {
      type: Object,
      default: () => {return {}}
    },
    textStyle: {
      type: Object,
      default: () => {return {}}
    }    
  }
}
</script>
