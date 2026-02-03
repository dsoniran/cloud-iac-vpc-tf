# Challenge

<ol>
  <li>First item</li>
  <li>Second item</li>
  <li>Third item
    <ol>
      <li>Indented item</li>
      <li>Indented item</li>
    </ol>
  </li>
  <li>Fourth item</li>
</ol>

1. Work out what is wrong with your app and db deployment (inside your VPC)

    1. Check SG rules
    b. Check DB_HOST connection string
    c. Check VPC settings again

2. Remake the VPC again, document in depth this time (Screenshots and step by step guidance). Steps below (at a glance)

    a. Make VPC (10.0.0.0/16)
    b. Make Subnets (10.0.2.0/24 and 10.0.3.0/24)
    c. Create IG and attach to VPC
    d. Create Public RT

    i. Associate with public subnet
    ii. Add route to the internet via IG  (0.0.0.0/0)

    e. Check setup
    f. Try to deploy app and db

3. Try to automate app and db deployment in your VPC by using your own images and user data 

**Reminder!** All of this is optional! We will catch up tomorrow and get everyone's deployment working before we move on 🙂

- Luke is available until 17:00
- AWS available until 19:30
- Do not work too hard! This is your time so use as you see fit
- Please join the call tomorrow at 09:00, we will start training proper at 09:30
- Recording will be available as soon as possible