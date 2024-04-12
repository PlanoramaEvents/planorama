<template>
<div class="container-fluid scrollable">
  <h1>Preview features</h1>
  <h2>Metro stations</h2>
  <div class="border border-dark w-75 p-4 special-box">

  <stepper2 id="stepper1" :steps="['paris']" v-model="selected1"></stepper2>
  <stepper2 id="stepper2" :steps="['in', 'the']" v-model="selected2"></stepper2>
  <stepper2 id="stepper3" :steps="['before publish', 'draft', 'firm like the jello that we love to eat']" v-model="selected3"></stepper2>
  <stepper2 id="stepper4" :steps="['stage A', 'supercalifragilisticexpialidocious', 'hi anna', 'hi gail']" v-model="selected4"></stepper2>
  <stepper2 id="stepper5" :steps="['there', 'once', 'was', 'a', 'woman']" v-model="selected5"></stepper2>
  <stepper2 id="stepper6" :steps="['it is', 'almost', 'time for', 'passover', 'and i clearly have no', 'meds left in my system']" v-model="selected6"></stepper2>
  <pre>selected: {{ selected6 }}</pre>
  <stepper2 id="stepper7" :steps="['gail', 'gail2', 'gail3', 'gail4', 'gail5', 'gail6', 'gail gail gail gail gail gail gail gail gail']"></stepper2>
  <stepper2 id="stepper8" :steps="['gail1', 'gail2', 'gail3', 'gail4', 'gail5', 'gail6', 'gail gail gail gail gail gail gail gail gail', 'gail8']"></stepper2>
  <stepper2 id="stepper9" :steps="['gail', 'gailie', 'supercalifragilisticexpialidocious', 'firm like the jello that we love to eat', 'firm like the poop that we do not love to eat', 'gaile', 'gail gail gail gail gail gail gail gail gail', 'gailo', 'anna']"></stepper2>
  </div>
</div>
</template>

<script>
import TwoSidedMultiSelect from "@/components/two_sided_multi_select.vue";
import Stepper2 from "@/components/stepper2.vue";

export default {
  name: "PlayGroundComponent",
  components: {
    TwoSidedMultiSelect,
    Stepper2
  },
  data: () => ({
    multiSelectOptions: ["one", "two", "three", "four", "five", "six"],
    multiSelectValue: ["two", "three", "six"],
    selected6: undefined,
    selected5: undefined,
    selected4: undefined,
    selected3: undefined,
    selected2: undefined,
    selected1: undefined
  })
}
</script>

<style>
.special-box {
  min-width: 50rem;
}
</style>
