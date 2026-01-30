/**
 * GitHub API로 파일 푸시 (Git 없이)
 * 환경변수 GITHUB_TOKEN 필요: GitHub > Settings > Developer settings > Personal access tokens
 */
import https from 'https';
import fs from 'fs';
import path from 'path';

const OWNER = 'sewoong333';
const REPO = 'CFO190';
const TOKEN = process.env.GITHUB_TOKEN;

const FILES = [
  'index.html',
  'refund-policy.html',
  'styles.css',
  'vercel.json',
  'package.json',
  'README.md',
  'push-and-deploy.ps1',
];

function api(method, path, body) {
  return new Promise((resolve, reject) => {
    const opts = {
      hostname: 'api.github.com',
      path,
      method,
      headers: {
        'Authorization': `token ${TOKEN}`,
        'Accept': 'application/vnd.github.v3+json',
        'User-Agent': 'CFO190-Deploy',
      },
    };
    const req = https.request(opts, (res) => {
      let data = '';
      res.on('data', (c) => (data += c));
      res.on('end', () => {
        try {
          resolve({ status: res.statusCode, data: data ? JSON.parse(data) : null });
        } catch {
          resolve({ status: res.statusCode, data });
        }
      });
    });
    req.on('error', reject);
    if (body) req.write(JSON.stringify(body));
    req.end();
  });
}

async function getFileSha(filePath) {
  const res = await api('GET', `/repos/${OWNER}/${REPO}/contents/${filePath}`);
  if (res.status === 200 && res.data && res.data.sha) return res.data.sha;
  return null;
}

async function putFile(filePath, content, message) {
  const sha = await getFileSha(filePath);
  const body = {
    message,
    content: Buffer.from(content).toString('base64'),
    sha: sha || undefined,
  };
  const res = await api('PUT', `/repos/${OWNER}/${REPO}/contents/${filePath}`, body);
  return res.status === 200;
}

async function main() {
  if (!TOKEN) {
    console.error('GITHUB_TOKEN 환경변수가 없습니다.');
    console.error('GitHub > Settings > Developer settings > Personal access tokens 에서 토큰 생성 후');
    console.error('PowerShell: $env:GITHUB_TOKEN = "토큰"; node deploy-via-api.mjs');
    process.exit(1);
  }

  const dir = path.resolve(path.dirname(process.argv[1] || '.'));

  for (const file of FILES) {
    const fullPath = path.join(dir, file);
    if (!fs.existsSync(fullPath)) continue;
    const content = fs.readFileSync(fullPath, 'utf8');
    const ok = await putFile(file, content, '푸터 사업자정보 반영 및 배포');
    console.log(ok ? `OK: ${file}` : `FAIL: ${file}`);
  }

  console.log('GitHub 푸시 완료.');
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
