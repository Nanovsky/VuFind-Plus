{if (isset($title)) }
<script type="text/javascript">
  alert("{$title}");
</script>
{/if}
<script type="text/javascript">
{literal}
$(function() {
	$( "#dateFilterStart" ).datepicker();
});
$(function() {
	$( "#dateFilterEnd" ).datepicker();
});
{/literal}
</script>
<div id="page-content" class="content">
	<div id="sidebar">
		{include file="MyResearch/menu.tpl"}
		{include file="Admin/menu.tpl"}
	</div>

	<div id="main-content">
		{if $user}
			<div class="myAccountTitle">
				<h1>Reports - External Link Tracking</h1>
			</div>
			<div class="myAccountTitle">
				<form method="get" action="" id="reportForm" class="search">
					<div id="filterContainer">
						<div id="filterLeftColumn">
							<div id="startDate">
								Start Date:
								<input id="dateFilterStart" name="dateFilterStart" value="{$selectedDateStart}" />
							</div>
							<div id="roles">
								Hosts: <br/>
								<select id="hostFilter[]" name="hostFilter[]" multiple="multiple" size="5" class="multiSelectFilter">
									{foreach from=$hostFilter item=resultHostFilter}
										<option value="{$resultHostFilter}" {if $resultHostFilter|in_array:$selectedHosts}selected='selected'{/if}>{$resultHostFilter}</option>
									{/foreach}
								</select>
							</div>
						</div>
						<div id="filterRightColumn">
							<div id="endDate">
								End Date:
								<input id="dateFilterEnd" name="dateFilterEnd" value="{$selectedDateEnd}" />
							</div>

							<div class="filterPlaceholder">

							</div>
						</div>
						<div class="divClear">
						</div>
						<input type="submit" id="filterSubmit" value="Go">
					</div>
				</div>
					{if $chartPath}
						<div id="chart">
							<img src="{$chartPath}" />
						</div>
					{/if}

					<div id="reportSorting">
		        {if $pageLinks.all}
		          {translate text="Showing"}
		          <b>{$recordStart}</b> - <b>{$recordEnd}</b>
		          {translate text='of'} <b>{$recordCount}</b>
		          {if $searchType == 'basic'}{translate text='for search'}: <b>'{$lookfor|escape:"html"}'</b>,{/if}
		        {/if}

		        <select name="reportSort" id="reportSort" onchange="this.form.submit();">
			        {foreach from=$sortList item=sortListItem key=keyName}
			          <option value="{$sortListItem.column}" {if $sortListItem.selected} selected="selected"{/if} >Sort By {$sortListItem.displayName}</option>
			        {/foreach}
		        </select>

						<b>Results Per Page: </b>
						<select name="itemsPerPage" id="itemsPerPage" onchange="this.form.submit();">
			        {foreach from=$itemsPerPageList item=itemsPerPageItem key=keyName}
			          <option value="{$itemsPerPageItem.amount}" {if $itemsPerPageItem.selected} selected="selected"{/if} >{$itemsPerPageItem.amount}</option>
			        {/foreach}
		        </select>
					</div>

					<table border="0" width="100%" class="datatable">
					  <tr>
							<th align="center">Record Id</th>
						  <th align="center">Title</th>
						  <th align="center">Url</th>
							<th align="center">Host</th>
						  <th align="center">Times Followed</th>
					  </tr>
						{section name=curLink loop=$resultLinks}
					    <tr {if $smarty.section.nr.iteration is odd} bgcolor="#efefef"{/if}>
						    <td><a href='{$resultLinks[curLink].recordUrl}'>{$resultLinks[curLink].recordId}</a></td>
						    <td>{$resultLinks[curLink].title}</td>
						    <td>{$resultLinks[curLink].linkUrl}</td>
					      <td>{$resultLinks[curLink].linkHost}</td>
								<td>{$resultLinks[curLink].timesFollowed}</td>
					    </tr>
						{sectionelse}
							<tr><td align="center" colspan="4"><br /><b>No External Links Found </b> <br /> </td></tr>
						{/section}
					</table>

          {if $pageLinks.all}<div class="pagination" id="pagination-bottom">Page: {$pageLinks.all}</div>{/if}
					<div class="exportButton">
						<input type="submit" id="exportToExcel" name="exportToExcel" value="Export to Excel">
					</div>
				</form>
			</div>
		{else}
		  You must login to view this information. Click <a href="{$path}/MyResearch/Login">here</a> to login.
		{/if}
	</div>
</div>