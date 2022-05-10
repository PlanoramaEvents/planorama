<template>
<div>
        <div class="d-flex flex-row mt-3">
          <div class="w-50 mr-2">
            <h5>Demographics</h5>
            <dl>
              <dt>Ethnicity</dt>
              <dd class="ml-2">{{selected.ethnicity | na_if_empty}}</dd>
              <dt>Gender</dt>
              <dd class="ml-2">{{selected.gender | na_if_empty}}</dd>
              <dt>Age at time of Event</dt>
              <dd class="ml-2">{{selected.age_at_convention | na_if_empty}}</dd>
              <dt>Romantic and/or sexual orientation</dt>
              <dd class="ml-2">{{selected.romantic_sexual_orientation | na_if_empty}}</dd>
            </dl>
          </div>
          <div class="w-50">
            <h5>Community memberships</h5>
            <dl>
              <dt>Experience with being “othered”</dt>
              <dd class="ml-2">{{selected.othered | na_if_empty }}</dd>
              <dt>Member of an Indigenous community</dt>
              <dd class="ml-2">{{selected.indigenous | na_if_empty}}</dd>
              <dt>Member of the global Black diaspora</dt>
              <dd class="ml-2">{{selected.black_diaspora | na_if_empty}}</dd>
              <dt>Represent something other than a purely US-centric perspective</dt>
              <dd class="ml-2">{{selected.non_us_centric_perspectives| na_if_empty}}</dd>
              <dt>Other demographic categories</dt>
              <dd class="ml-2">{{selected.demographic_categories | na_if_empty }}</dd>
            </dl>
          </div>
          </div>
        </div>
</template>

<script>import { modelMixin } from "@/mixins";

export default {
  name: "PersonDemographics",
  props: ['selected'],
  mounted() {
    console.log("what gives yo")
  }
}
</script>

<style>

</style>
