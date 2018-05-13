<template>
  <div class="container-fluid" style="margin-top: 2em;">
  
    <div class="row align-items-center justify-content-center">
      <div class="col-10">
  
        <h3>About the Portal</h3>
  
        <p>
          This is an open access online data portal and visualization designed to help users explore
          the existing evidence on linkages between nature and people. The evidence collated in this
          tool is designed to help conservation and development policymakers, practitioners, and researchers
          identify relevant information for decision-making. To date, the portal hosts 3 evidence maps
          containing nearly 1,500 peer-reviewed articles, unpublished reports, and theses in the evidence base.
          You can access each of these evidence maps through the EXPLORE THE DATA menu above.
        </p>
  
        <p>
          The portal provides a gateway to filter and visualize patterns in these evidence maps and download
          subsets of the data and relevant bibliographies. Most of the generated plots on this page are made
          using <a href="https://vega.github.io/vega/">Vega</a>, therefore you can use the interact with each
          graph, as well as download them. Any data, graphs, or summaries downloaded from this
          tool must be cited appropriately.
        </p>
  
        <p>
          Below, you will find an instructional video about how to use the tool as well as a set of FAQs.
        </p>

        <h3>How to Use the Portal</h3>
        <p>Short video tutorial on using the EBC data portal (video link)</p>

        <h3>FAQs</h3>
        <h5>I am looking for a specific action or outcome, how do I find out what category that falls into?</h5>
        <p>
          The glossary is the best place to figure out what types of actions or outcomes fall into which categories. Since we used either standardized typologies or synthesized frameworks, the definitions stem from those references. Below the definition, you find examples of what types of actions are included. The glossary can be found at the bottom of every page. Click the 'Show/Hide glossary' button to display the panel. You can also find the glossary in the <span style="color:#006666; font-weight:bold;">ABOUT</span> section, and then navigating to <span style="color:#006666; font-weight:bold;">GLOSSARY</span>.
        </p>
        <h5>Where do I filter data and explore it? Why are there so many different options?</h5>
        <p>
          This site is constantly in development and we are refining it to make searching for and exploring data as functional and intuitive as possible. As well, while Shiny is a fantastic method for visualizing data, it can be difficult to incorporate multiple elements that it is not designed for. Hence, there are different tabs for exploring data. We encourage you to watch the how-to video on how to explore, filter, and download data.
        </p>
        <p>
          In general, options for exploration are located in the <span style="color:#006666; font-weight:bold;">EXPLORE</span> section. Within this section, in the <span style="color:#006666; font-weight:bold;">VISUALIZATION</span> tab, you can filter data from an individual evidence synthesis by geography, intervention/action type, outcome type, study design, and habitat. This data is displayed in a number of visualizations displaying the resulting number of unique articles. Here you can view summaries of different variables, explore the full data, and visualize spatially on both choropleth and interactive maps. You can also view the data table behind this map by clicking on the <span style="color:#006666; font-weight:bold;">TABLE</span> tab.
        </p>
        <h5>Are there other efforts to expand from this evidence map or on other topics?</h5>
        <p>
          You can read more about ongoing work to build this evidence base and conduct in-depth syntheses on some of these linkages in the <span style="color:#006666; font-weight:bold;">RESEARCH</span> tab.
        </p>

        <h3>Feedback</h3>
        <p>
          As this tool is designed to help users find and explore usable data, feedback would be
          very much appreciated on functionality and utility. Please see the CONTACT tab to fill
          out a feedback form.

          For any questions or comments, please contact Samantha Cheng (
            <a href="mailto:samantha.cheng@asu.edu">samantha.cheng@asu.edu</a>
          ).
        </p>
      </div>
    </div>

    <div class="row align-items-center justify-content-center alternate-row" style="padding-bottom: 50px;">
      <div class="col-10">
        <h3>Acknowledgments</h3>
  
        <p>
          The concept for the Evidence for Nature and People Data Portal was conceived by the
          Evidence-Based Conservation Working Group. This portal is supported by the Science
          for Nature and People Partnership consisting of the National Center for Ecological
          Analysis and Synthesis (NCEAS), The Nature Conservancy, and the Wildlife Conservation Society.
          Without the technical expertise and computing support from the scientific computing team
          at NCEAS (Julien Brun, Nick Outin, Ian McCullough, Sarah McCutcheon, Justin Kroes,
          Mark Schildhauer, &amp; Lauren Walker) this tool would not have been possible.
          The current version of the tool is built by Kenton Russell using multiple open source technologies.
          This tool was developed and piloted with a number of potential end-users including scientists, researchers,
          and practitioners from multiple academic, conservation, and development institutions and agencies.
        </p>  
      </div>
    </div>
  
    <div class="row align-items-center justify-content-center" style="margin-bottom: 50px;">
    </div>
  </div>
</template>

<style scoped>
  .row.alternate-row {
    background-color:#383838;
    color: white;
  }
  .row.alternate-row h3 {
    color:#eec919;
    margin-top:30px;
    margin-bottom:30px;
  }
  .row.alternate-row a {
    color: white;
  }
</style>
