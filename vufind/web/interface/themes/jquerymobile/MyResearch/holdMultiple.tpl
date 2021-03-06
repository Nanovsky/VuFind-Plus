<script type='text/javascript' src='{$path}/services/Record/ajax.js'></script>
<div data-role="page">
	{include file="header.tpl"}
	<div data-role="content" >
		<form name='placeHoldForm' id='placeHoldForm' action="{$path}/MyResearch/HoldMultiple" method="post">
			<div class="holdsSummary">
				<h3>Placing holds on <span id='newHoldCount'>{$ids|@count}</span> titles.</h3>
				{foreach from=$ids item=id}
					<input type="hidden" name="selected[{$id|escape:url}]" value="on" />
				{/foreach}
				<ol class="showNumbers">
				{foreach from=$holdings item=holding}
					<li>{$holding}</li>
				{/foreach}
				</ol>
				<input type="hidden" name="holdCount" id="holdCount" value="{$ids|@count}"/>
				<div class="pageWarning" id="overHoldCountWarning" {if !$showOverHoldLimit}style="display:none"{/if}>Warning: There is a maximum of <span class='maxHolds'>{$maxHolds}</span> holds allowed on your account.  You currently have <span class='currentHolds'>{$currentHolds}</span> on your account. Holds for more than <span class='maxHolds'>{$maxHolds}</span> will not be placed.</div>
			</div>
			{if $holdDisclaimer}
				<div id="holdDisclaimer">{$holdDisclaimer}</div>
			{/if}
			<p class="note">
				Holds allow you to request that a title be delivered to your home library.
				Once the title arrives at your library you will be sent an e-mail, receive a phone call, or receive a postcard informing you that the title is ready for you.
				You will then have 8 days to pickup the title from your home library.
			</p>
			{foreach from=$ids item=id}
				 <input type="hidden" name="selected[{$id|escape:url}]" value="on">
			{/foreach}
			{if (!isset($profile)) }
			<div data-role="fieldcontain">
				<label for="username">{translate text='Username'}:</label>
				<input type="text" name="username" id="username" size="40"><br/>
				<label for="username">{translate text='Password'}:</label>
				<input type="password" name="password" id="password" size="40"><br/>
				<a href="#" id="loginButton" data-role="button" onclick="GetPreferredBranches('{$id|escape}');return false;" >Login</a>
			</div>
			{/if}
			<div data-role="fieldcontain">
				<div id='holdOptions' {if (!isset($profile)) }style='display:none'{/if}>
					<div id='pickupLocationOptions'>
						<label for="campus">{translate text="I want to pick this up at"}:</label>
						<select name="campus" id="campus" data-role="none">
							{foreach from=$pickupLocations item=location key=value}
								<option value="{$location->code}" {if $location->selected == "selected"}selected="selected"{/if}>{$location->displayName}</option>
							{/foreach}
						</select>
					</div>
					{if $showHoldCancelDate == 1}
						<div id='cancelHoldDate'>
							<label for="canceldate">{translate text="Automatically cancel this hold if not filled by"}:</label>
							<input type="text" name="canceldate" id="canceldate" size="10">
							<br /><i>If this date is reached, the hold will automatically be cancelled for you.	This is a great way to handle time sensitive materials for term papers, etc. If not set, the cancel date will automatically be set 6 months from today.</i>
						</div>
					{/if}
					<br />
					<input type="hidden" name="holdType" value="hold">
					<a href="#" data-role="button" id="requestTitleButton" {if (!isset($profile))}disabled="disabled"{/if} onclick="document.placeHoldForm.submit();" >{translate text='Submit Hold Request'}</a>
				</div>
			</div>
		</form>
	</div>		
	{include file="footer.tpl"}
</div>
