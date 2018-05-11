<template>
  <Vega
    v-if="spec !== null" :spec="spec"
    :use-viewbox = "useViewbox"
    :use-tooltip = "useTooltip"
    :tooltip-options = "tooltipOptions"
  ></Vega>
</template>

<script>
import Vega from './Vega.vue'

export default {
  components: {
    Vega
  },
  props: ["spec", "useViewbox", "useTooltip", "tooltipOptions"]
}
</script>
