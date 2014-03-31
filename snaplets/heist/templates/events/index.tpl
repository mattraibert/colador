<apply template="base">
  <table class="table">
    <thead>
      <th>Title</th>
      <th>Citation</th>
      <th></th>
      <th></th>
    </thead>
    <tbody>
      <events>
	<tr>
	  <td><eventTitle /></td>
	  <td><eventCitation /></td>
	  <td><a href="${editLink}">edit</a></td>
	  <td>
	    <form action="${eventLink}" method='POST'>
	      <input type='hidden' name='_method' value='DELETE' />
	      <input type='submit' value='X' />
	    </form>
	  </td>
	</tr>
      </events>
    </tbody>
  </table>
  <a class='btn btn-default pull-right' style='border: red 1px solid;' href='/events/new'>New Event</a>
</apply>
