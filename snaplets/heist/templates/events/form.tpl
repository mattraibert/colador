<apply template="base">
  <dfForm class="form-event">
    <dfInputText ref="title" size="60" placeholder="Title"/>
    <dfChildErrorList ref="title" />
    <dfInputText ref="startYear" size="60" placeholder="StartYear"/>
    <dfChildErrorList ref="startYear" />
    <dfInputText ref="endYear" size="60" placeholder="EndYear"/>
    <dfChildErrorList ref="endYear" />
    <dfInputText ref="location" size="60" placeholder="location..."/>
    <dfChildErrorList ref="location" />
    <dfInputText ref="citation" size="60" placeholder="Citation"/>
    <dfChildErrorList ref="citation" />
    <dfInputTextArea ref="content" rows="20" cols="80" placeholder="Event content goes here... "/>
    <dfChildErrorList ref="content" />
    <dfInputSubmit value="Enter" class="btn btn-lg btn-primary btn-block" />
  </dfForm>
</apply>
