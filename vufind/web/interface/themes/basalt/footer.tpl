{* Your footer *}
<div class="footerCol"><p><strong>{translate text='Featured Items'}</strong></p>
	<ul>
		<li><a href='{$path}/Search/Results?lookfor=&amp;type=Keyword&amp;filter[]=local_time_since_added_basalt%3A"Week"'>{translate text='New This Week'}</a></li>
		<li><a href='{$path}/Search/Results?lookfor=&amp;type=Keyword&amp;filter[]=local_time_since_added_basalt%3A"Month"&amp;filter[]=literary_form_full%3A"Fiction"'>{translate text='New Fiction'}</a></li>
		<li><a href='{$path}/Search/Results?lookfor=&amp;type=Keyword&amp;filter[]=local_time_since_added_basalt%3A"Month"&amp;filter[]=literary_form_full%3A"Non+Fiction"'>{translate text='New Non-Fiction'}</a></li>
		<li><a href='{$path}/Search/Results?lookfor=&amp;type=Keyword&amp;filter[]=itype_basalt%3A"DVD+New"'>{translate text='New DVDs'}</a></li>
		<li><a href='{$path}/Search/Results?lookfor=&amp;type=Keyword&amp;filter[]=itype_basalt%3A"Juvenile+DVD+fiction"&amp;filter[]=local_time_since_added_basalt%3A"Six+Months"'>{translate text='New Juvenile DVDs'}</a></li>
		<li><a href='{$path}/Search/Results?lookfor=&amp;type=Keyword&amp;filter[]=local_time_since_added_basalt%3A"Month"&amp;filter[]=format_category%3A"Audio+Books"'>{translate text='New Audio Books &amp; CDs'}</a></li>
		<li><a href='{$path}/Search/Results?lookfor="Seed+Library"&amp;type=Subject'>{translate text='Basalt Seed Library'}</a></li>
	</ul>
</div>
<div class="footerCol"><p><strong>{translate text='Search Options'}</strong></p>
	<ul>
		{if $user}
		<li><a href="{$path}/Search/History">{translate text='Search History'}</a></li>
		{/if}
		<li><a href="{$path}/Search/Results">{translate text='Standard Search'}</a></li>
		<li><a href="{$path}/Search/Advanced">{translate text='Advanced Search'}</a></li>
	</ul>
</div>
<div class="footerCol"><p><strong>{translate text='Find More'}</strong></p>
	<ul>
		<li><a href="http://marmot.lib.overdrive.com" rel="external" onclick="window.open (this.href, 'child'); return false">{translate text='Download Books &amp; More'}</a></li>
		<li><a href="http://www.basaltlibraryevents.org/VirtualEMS/BrowseEvents.aspx">{translate text='Events'}</a></li>
	</ul>
</div>
<div class="footerCol"><p><strong>{translate text='Need Help?'}</strong></p>
	<ul>
		<li><a href="{$path}/Help/Home?topic=search" onclick="window.open('{$path}/Help/Home?topic=search', 'Help', 'width=625, height=510'); return false;">{translate text='Search Tips'}</a></li>
		<li><a href="{$askALibrarianLink}" rel="external" onclick="window.open (this.href, 'child'); return false">{translate text='Ask a Librarian'}</a></li>
		{if isset($illLink)}
				<li><a href="{$illLink}" rel="external" onclick="window.open (this.href, 'child'); return false">{translate text='Interlibrary Loan'}</a></li>
		{/if}
		{if isset($suggestAPurchaseLink)}
				<li><a href="{$suggestAPurchaseLink}" rel="external" onclick="window.open (this.href, 'child'); return false">{translate text='Suggest a Purchase'}</a></li>
		{/if}
		<li><a href="{$path}/Help/Home?topic=faq" onclick="window.open('{$path}/Help/Home?topic=faq', 'Help', 'width=625, height=510, scrollbars=yes'); return false;">{translate text='FAQs'}</a></li>
	</ul>
</div>
<div class="footerCol"><p><strong>{translate text='About us'}</strong></p>
	<ul>
		<li><a href="http://www.basaltrld.org">{translate text='Library Home'}</a></li>
		<li>
			14 Midland Ave.<br/>
			Basalt, CO 81621<br/>
			<b>(970) 927-4311</b><br/>
		</li>
	</ul>
</div>
<div class="footerCol">
	<p><strong>{translate text='Hours of Operation'}</strong></p>
	<ul>
		<li>
		<b>Monday - Thursday: </b><br/>
		&nbsp;&nbsp;10 am to 7 pm<br/>
		<b>Friday - Saturday: </b><br/>
		&nbsp;&nbsp;10 am to 5 pm<br/>
		<b>Sunday:</b><br/>
		&nbsp;&nbsp;12 pm to 5 pm<br/>
		</li>
	</ul>
</div>
<br class="clearer"/>
{if !$productionServer}
<div class='location_info'>{$physicalLocation}</div>
{/if}