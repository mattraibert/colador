<apply template="base">
  <dfForm class="form-event">
    <dfInputText ref="title" size="60" placeholder="Title"/>
    <dfChildErrorList ref="title" />
    <dfInputText ref="citation" size="60" placeholder="Citation"/>
    <dfChildErrorList ref="citation" />
    <dfInputTextArea ref="content" rows="20" cols="80" placeholder="Event content goes here... "/>
    <dfChildErrorList ref="content" />
    <dfInputSubmit value="Enter" class="btn btn-lg btn-primary btn-block" />
  </dfForm>
</apply>