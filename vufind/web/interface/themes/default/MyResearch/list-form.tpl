<div onmouseup="this.style.cursor='default';" id="popupboxHeader" class="header">
	<a onclick="hideLightbox(); return false;" href="">close</a>
	{translate text='Create a new List'}
</div>
<div id="popupboxContent" class="content">
	{if $listError}<p class="error">{$listError|translate}</p>{/if}
	<form method="post" action="{$path}/MyResearch/ListEdit" name="listForm"
	      onSubmit='addList(this, &quot;{translate text='add_list_fail'}&quot;); return false;'>
	  {translate text="List"}:<br />
	  <input type="text" id="listTitle" name="title" value="{$list->title|escape:"html"}" size="50"><br />
	  {translate text="Description"}:<br />
	  <textarea name="desc" id="listDesc" rows="3" cols="50">{$list->desc|escape:"html"}</textarea><br />
	  {translate text="Access"}:<br />
	  {translate text="Public"} <input type="radio" name="public" value="1">
	  {translate text="Private"} <input type="radio" name="public" value="0" checked><br />
	  <input type="submit" name="submit" value="{translate text="Save"}">
	  <input type="hidden" name="recordId" value="{$recordId}">
	  <input type="hidden" name="source" value="{$source}">
	  <input type="hidden" name="followupModule" value="{$followupModule}">
	  <input type="hidden" name="followupAction" value="{$followupAction}">
	  <input type="hidden" name="followupId" value="{$followupId}">
	  <input type="hidden" name="followupText" value="{translate text='Add to Favorites'}">
	</form>
</div>
