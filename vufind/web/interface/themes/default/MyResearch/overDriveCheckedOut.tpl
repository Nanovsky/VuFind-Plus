{strip}
<script type="text/javascript" src="{$path}/services/MyResearch/ajax.js"></script>
{if (isset($title)) }
<script type="text/javascript">
	alert("{$title}");
</script>
{/if}
<div id="page-content" class="content">
	<div id="sidebar">
		{include file="MyResearch/menu.tpl"}
		{include file="Admin/menu.tpl"}
	</div>
  
	<div id="main-content">
	{if $user}
		{if $profile.web_note}
			<div id="web_note">{$profile.web_note}</div>
		{/if}
			
		<div class="myAccountTitle">{translate text='Your Checked Out Items In OverDrive'}</div>
		{if $userNoticeFile}
			{include file=$userNoticeFile}
		{/if}

		{if $overDriveCheckedOutItems}
			<div class='sortOptions'>
				Hide Covers <input type="checkbox" onclick="$('.imageColumnOverdrive').toggle();"/>
			</div>
		{/if}

		{if count($overDriveCheckedOutItems) > 0}
			<table class="myAccountTable">
				<thead>
					<tr><th class='imageColumnOverdrive'></th><th>Title</th><th>Checked Out On</th><th>Expires</th><th>Format</th><th>Rating</th><th></th></tr>
				</thead>
				<tbody>
				{foreach from=$overDriveCheckedOutItems item=record}
					<tr>
						<td {if $record.numRows}rowspan="{$record.numRows}"{/if} class='imageColumnOverdrive'>
							<img src="{$record.imageUrl}" alt="Cover Image" />
						</td>
						<td>
							{if $record.recordId != -1}<a href="{$path}/EcontentRecord/{$record.recordId}/Home">{/if}{$record.title}{if $record.recordId != -1}</a>{/if}
							{if $record.subTitle}<br/>{$record.subTitle}{/if}
							{if strlen($record.record->author) > 0}<br/>by: {$record.record->author}{/if}
						</td>
						<td>{$record.checkedOutOn}</td>
						<td>{$record.expiresOn}</td>
						<td>{$record.format}</td>
						<td>{* Ratings cell*}
							{if $record.recordId != -1}
							<div class="resultActions">
								{include file="EcontentRecord/title-rating.tpl" ratingClass="" recordId=$record.recordId shortId=$record.recordId ratingData=$record.ratingData}
								{assign var=id value=$record.recordId}
								{include file="EcontentRecord/title-review.tpl"}
 							</div>

							{/if}
						</td>
						<td>
							<a href="{$record.downloadLink|replace:'&':'&amp;'}" class="button">Download</a>
						</td>
					</tr>
				{/foreach}
				</tbody>
			</table>
		{else}
			<div class='noItems'>You do not have any titles from OverDrive checked out</div>
		{/if}
		<div id='overdriveMediaConsoleInfo'>
		<img src="{$path}/images/overdrive.png" width="125" height="42" alt="Powered by Overdrive" class="alignleft"/>
		<p>To access OverDrive titles, you will need the <a href="http://www.overdrive.com/software/omc/">OverDrive&reg; Media Console&trade;</a>.  
		If you do not already have the OverDrive Media Console, you may download it <a href="http://www.overdrive.com/software/omc/">here</a>.</p>
		<div class="clearer">&nbsp;</div> 
		<p>Need help transferring a title to your device or want to know whether or not your device is compatible with a particular format?
		Click <a href="http://help.overdrive.com">here</a> for more information. 
		</p>
		 
	</div>
	{else}
		You must login to view this information. Click <a href="{$path}/MyResearch/Login">here</a> to login.
	{/if}
	</div>
</div>
{/strip}