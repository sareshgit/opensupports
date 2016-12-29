describe'system/edit-settings' do
        request('/user/logout')
        Scripts.login($staff[:email], $staff[:password], true)

        it 'should edit settings' do
            result= request('/system/edit-settings', {
                "csrf_userid" => $csrf_userid,
                "csrf_token" => $csrf_token,
                "maintenance-mode" => 1,
                "time-zone" => -3,
                "layout" => 'full-width',
                "allow-attachments" => 1,
                "max-size" => 2,
                "language" => 'es',
                "no-reply-email" => 'testemail@hotmail.com',
                "smtp-host" => 'www.opensupports.com',
                "smtp-port" => 18,
                "smtp-user" => 'admin',
                "smtp-pass" => 'pass1234',
            })

            (result['status']).should.equal('success')

            row = $database.getRow('setting', 'maintenance-mode', 'name')
            (row['value']).should.equal('1')

            row = $database.getRow('setting', 'time-zone', 'name')
            (row['value']).should.equal('-3')

            row = $database.getRow('setting', 'layout', 'name')
            (row['value']).should.equal('full-width')

            row = $database.getRow('setting', 'max-size', 'name')
            (row['value']).should.equal('2')

            row = $database.getRow('setting', 'language', 'name')
            (row['value']).should.equal('es')

            row = $database.getRow('setting', 'no-reply-email', 'name')
            (row['value']).should.equal('testemail@hotmail.com')

            row = $database.getRow('setting', 'smtp-host', 'name')
            (row['value']).should.equal('www.opensupports.com')

            row = $database.getRow('setting', 'smtp-port', 'name')
            (row['value']).should.equal('18')

            row = $database.getRow('setting', 'smtp-user', 'name')
            (row['value']).should.equal('admin')

            row = $database.getRow('setting', 'smtp-pass', 'name')
            (row['value']).should.equal('pass1234')

            request('/user/logout')

            lastLog = $database.getLastRow('log')
            (lastLog['type']).should.equal('EDIT_SETTINGS')
        end
        it 'should change allowed and supported languages' do
            request('/user/logout')
            Scripts.login($staff[:email], $staff[:password], true)

            result= request('/system/edit-settings', {
                "csrf_userid" => $csrf_userid,
                "csrf_token" => $csrf_token,
                "supportedLanguages" => '["en", "pr", "jp", "ru"]',
                "allowedLanguages" => '["en","pr", "jp", "ru", "de"]'
            })

            (result['status']).should.equal('success')

            row = $database.getRow('language', 'en', 'code')
            (row['supported']).should.equal('1')

            row = $database.getRow('language', 'pr', 'code')
            (row['supported']).should.equal('1')

            row = $database.getRow('language', 'jp', 'code')
            (row['supported']).should.equal('1')

            row = $database.getRow('language', 'ru', 'code')
            (row['supported']).should.equal('1')

            row = $database.getRow('language', 'en', 'code')
            (row['allowed']).should.equal('1')

            row = $database.getRow('language', 'pr', 'code')
            (row['allowed']).should.equal('1')

            row = $database.getRow('language', 'jp', 'code')
            (row['allowed']).should.equal('1')

            row = $database.getRow('language', 'ru', 'code')
            (row['allowed']).should.equal('1')

            row = $database.getRow('language', 'de', 'code')
            (row['allowed']).should.equal('1')

            lastLog = $database.getLastRow('log')
            (lastLog['type']).should.equal('EDIT_SETTINGS')

            request('/user/logout')
        end
end
