<template>
  <div>
    <svg width="20px" height="20px" viewBox="0 0 1792 1792" @click="exportGraph" @mouseover="hoverButton" @mouseout="hoverOut">
      <rect style="pointer-events:all; fill:none; stroke:none" height=1792 width=1792></rect>
      <g class="download-button">
        <path style="fill:#888;" d="M1344 1344q0-26-19-45t-45-19-45 19-19 45 19 45 45 19 45-19 19-45zm256 0q0-26-19-45t-45-19-45 19-19 45 19 45 45 19 45-19 19-45zm128-224v320q0 40-28 68t-68 28h-1472q-40 0-68-28t-28-68v-320q0-40 28-68t68-28h465l135 136q58 56 136 56t136-56l136-136h464q40 0 68 28t28 68zm-325-569q17 41-14 70l-448 448q-18 19-45 19t-45-19l-448-448q-31-29-14-70 17-39 59-39h256v-448q0-26 19-45t45-19h256q26 0 45 19t19 45v448h256q42 0 59 39z"/>
      </g>
    </svg>
    <div class="vega-chart"></div>
  </div>
</template>

<script>
import * as vega from 'vega';
import * as vegaTooltip from 'vega-tooltip';
import {select} from 'd3-selection';

export default {
  props: {
    spec: {
      type: Object,
      default: null
    },
    renderer: {
      default: 'svg'
    },
    autosize: {
      type: Object,
      default: () => {
        return {
          type: 'pad',
          contains: 'padding',
          autosize: true
        }
      }
    },
    width: {
      default: null
    },
    height: {
      default: null
    },
    padding: {
      default: null
    },
    background: {
      default: 'white'
    },
    hover: {
      default: 'hover'
    },
    useViewbox: {
      type: Boolean,
      default: true
    },
    useTooltip: {
      type: Boolean,
      default: true
    },
    tooltipOptions: {
      default: function() {
        return {
          showAllFields: true
        }
      }
    }
  },
  data: () => {
    return {
      view: {}
    }
  },
  mounted: function() {
    this.view = this.createView(this.spec);
  },
  beforeDestroy: function() {
    if(this.view) {
      this.view.finalize()
      this.view = null
    }
  },
  watch: {
    spec: {
      handler: function() {
        this.view = this.createView(this.spec);
      },
      deep: true
    }
  },
  methods: {
    createView: function(spec) {
      // very destructive way to rerender and not taking advantage of Vega DataFlow
      //  but for now we will go with this

      // should I view.finalize before re-render
      // if no spec finalize and destroy view
      if(this.view && this.view.finalize) {
        this.view.finalize()
      }

      if(spec) {
        const runtime = vega.parse(spec);
        const view = new vega.View(runtime);
        ['renderer', 'autosize', 'padding', 'width', 'height', 'padding', 'background', 'hover'].forEach( (setting) => {
          if(this[setting]) {
            try {
              view[setting](this[setting])
            } catch(e) {
              console.log('trouble applying setting to vega view', e);
            }
          }
        })
        
        view.initialize(select(this.$el).select('div.vega-chart').node());

        this.addSignalEmitter(spec, view);

        view.run();

        if(this.useViewbox) {
          select(this.$el).select('div.vega-chart svg')
            .style('width', '100%')
            .style('height', '100%')
        }

        if(this.useTooltip) {
          vegaTooltip.vega(view, this.tooltipOptions);
        }

        return view;
      }
    },
    addSignalEmitter: function(spec, view) {
      if(view && spec && spec.signals.length > 0) {
        spec.signals.forEach(signal => {
          view.addSignalListener(signal.name, (name,value) => this.$emit(name,value) )
        })
      }
    },
    exportGraph: function() {
      // generate a PNG snapshot and then download the image
      if(this.view) {
        this.view.toImageURL('png').then(function(url) {
          var link = document.createElement('a');
          link.setAttribute('href', url);
          link.setAttribute('target', '_blank');
          link.setAttribute('download', 'graph-export.png');
          link.dispatchEvent(new MouseEvent('click'));
        }).catch(function(error) { /* error handling */ });
      }
    },
    hoverButton: function() {
      select(this.$el).select('g.download-button path').style('fill', '#333')
    },
    hoverOut: function() {
      select(this.$el).select('g.download-button path').style('fill', '#888')
    }
  }

}
</script>
