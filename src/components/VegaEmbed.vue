<template>
  <div></div>
</template>

<script>
import {default as embed} from 'vega-embed'

export default {
  props: ['spec'],
  data: () => {
    return {
      view: null
    }
  },
  watch: {
    spec: {
      handler: function() {
        this.view = this.embedVega()
      },
      deep: true
    }
  },
  methods: {
    embedVega: function() {
      if(this.spec) {
        let view = this.$view;
        embed(this.$el, this.spec)
      }
    }
  }
}
</script>
