<template>
  <div class="col-12 tab-pane">
    <div class="row">
      <p>
        <em>
          Look up definitions for intervention, outcome, biome, and study design types used to categorize this evidence map. (See 
          <span style="color:#006699">
            <strong>ABOUT</strong>
          </span>
        </em>
        for more information)
      </p>
      <hr>
    </div>
    <div class="row justify-content-start glossary-groups">
      <div class="col col-sm-6 glossary-card">
        <div class="card">
          <div class="card-block">
            <h4 align="center" style="color:#006699">
              <strong>Intervention types</strong>
            </h4>
            <p>
              We use the 
              <a href="http://cmp-openstandards.org/using-os/tools/actions-taxonomy/">IUCN-Conservation Measures Partnership standardized typology</a>
                for conservation actions/intervention types.
            </p>
            <div class="form-group">
              <label class="control-label" for="intervention_def">Intervention type:</label>
              <div> 
                <select id="intervention_def" class="form-control" v-model="selected_intervention">
                    <option v-for="intervention in termtypes.intervention">
                      {{ intervention }}
                    </option>
                </select>
              </div>
            </div>
            <p></p>
            <div>
              <strong>Definition:</strong>
            </div>
            <p></p>
            <div id="int_def2">{{definition_intervention.Definition}}</div>
            <p></p>
            <div>
              <strong>Included Actions:</strong>
            </div>
            <p></p>
            <div id="int_def3">{{definition_intervention.Examples}}</div>
          </div>
        </div>
      </div>
      <div class="col col-sm-6 glossary-card">
        <div class="card">
          <div class="card-block">
            <h4 align="center" style="color:#006699">
              <strong>Human well-being outcomes</strong>
            </h4>
            <p>
              The outcome categories were synthesized from a number of sources including 
              <a href="http://www.mdpi.com/2071-1050/5/3/997">Leisher et al. 2013</a>
              , 
              <a href="http://www.conservationgateway.org/ConservationPractices/PeopleConservation/SocialScience/Pages/strengthening-social-impacts.aspx">Wongbusarakum et al. 2014</a>
              , and Masuda et al. 2015
            </p>
            <div class="form-group">
              <label class="control-label" for="outcome_def">Human well-being outcome:</label>
              <div> 
                <select id="outcome_def" class="form-control" v-model="selected_outcome">
                    <option v-for="outcome in termtypes.outcome">
                      {{ outcome }}
                    </option>
                </select>
              </div>
            </div>
            <p>
            </p>
            <div>
              <strong>Definition:</strong>
            </div>
            <p></p>
            <div id="out_def2">{{definition_outcome.Definition}}</div>
            <p></p>
            <div>
              <strong>Examples:</strong>
            </div>
            <p></p>
            <div id="out_def3">{{definition_outcome.Examples}}</div>
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col col-sm-6 glossary-card">
        <div class="card">
          <div class="card-block">
            <h4 align="center" style="color:#006699">
              <strong>Major habitat type, biome and ecoregion types</strong>
            </h4>
            <p>
              We used the World Wildlife Fund ecoregion 
              <a href="http://www.worldwildlife.org/biomes">definitions</a>
            </p>
            <div class="form-group">
              <label class="control-label" for="biome_def">Major habitat types</label>
              <div>
                <select id="biome_def" class="form-control" v-model="selected_biome">
                  <option v-for="biome in termtypes.biome">
                    {{ biome }}
                  </option>
                </select>
              </div>
            </div>
            <p></p>
            <div>
              <strong>Definition:</strong>
            </div>
            <p></p>
            <div id="bio_def2">{{definition_biome.Definition}}</div>
            <p></p>
            <div>
              <strong>Examples:</strong>
            </div>
            <p></p>
            <div id="bio_def3">{{definition_biome.Examples}}</div>
          </div>
        </div>
      </div>
      <div class="col col-sm-6 glossary-card">
        <div class="card">
          <div class="card-block">
            <h4 align="center" style="color:#006699">
              <strong>Study design types</strong>
            </h4>
            <p>
              Study design categories were adapted from 
              <a href="http://onlinelibrary.wiley.com/doi/10.1002/ev.298/abstract">Margoluis et al. 2009</a>
              .
            </p>
            <div class="form-group">
              <label class="control-label" for="study_def">Study design types</label>
              <div>
                <select id="study_def" class="form-control" v-model="selected_study">
                  <option v-for="study in termtypes.study">
                    {{ study }}
                  </option>
                </select>
              </div>
            </div>
            <p>
            </p>
            <div>
              <strong>Definition:</strong>
            </div>
            <p></p>
            <div id="study_def2">{{definition_study.Definition}}}</div>
            <p></p>
            <div>
              <strong>Examples:</strong>
            </div>
            <p></p>
            <div id="study_def3">{{definition_study.Examples}}</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import Definitions from "../definitions.js"
  import TermTypes from "../termtypelookup.js"

  export default {
    data: function() {
      return {
        definitions: Definitions(),
        termtypes: TermTypes(),
        selected_intervention: TermTypes().intervention[0],
        selected_outcome: TermTypes().outcome[0],
        selected_biome: TermTypes().biome[0],
        selected_study: TermTypes().study[0]
      }
    },
    computed: {
      definition_intervention: function() {
        return this.getDefinition(this.selected_intervention)
      },
      definition_outcome: function() {
        return this.getDefinition(this.selected_outcome)
      },
      definition_biome: function() {
        return this.getDefinition(this.selected_biome)
      },
      definition_study: function() {
        return this.getDefinition(this.selected_study)
      }
    },
    methods: {
      getDefinition: function(term) {
        return this.definitions.filter(function(d,i) {
          return d.Term === term
        })[0]
      }
    }
  }
</script>


<style scoped>
  .card {
    background-color: #ecf0f1;
    border-radius: 4px;
    margin-bottom: 1em;
  }
</style>