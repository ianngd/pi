document.addEventListener('DOMContentLoaded', () => {
  const dataInput = document.getElementById('data');
  const today = new Date().toISOString().split('T')[0];
  dataInput.value = today;

  const form = document.getElementById('demandForm');
  const backlogTbody = document.getElementById('backlogTable').getElementsByTagName('tbody')[0];
  const notificationIcon = document.getElementById('notificationIcon');
  const generateReportBtn = document.getElementById('generateReport');

  let demands = [];

  function updateNotificationIcon() {
    const hasCriticalPending = demands.some(d =>
      (d.origem === 'Interno e SUSEP' || d.origem === 'SUSEP') && d.status === 'Pendente'
    );
    notificationIcon.classList.toggle('d-none', !hasCriticalPending);
  }

  function createDownloadLink(filePath) {
    const link = document.createElement('a');
    link.href = filePath;
    link.textContent = 'Download';
    link.target = '_blank';
    return link;
  }

  function addDemandToTable(demand) {
    const row = backlogTbody.insertRow();
    row.dataset.produto = demand.produto;
    row.dataset.origem = demand.origem;
    row.dataset.status = demand.status;

    row.insertCell().textContent = demand.produto;
    row.insertCell().textContent = demand.origem;

    const statusCell = row.insertCell();
    const statusSelect = document.createElement('select');
    statusSelect.className = 'form-select';
    ['Pendente', 'Em execução', 'Concluído'].forEach(status => {
      const option = document.createElement('option');
      option.value = status;
      option.textContent = status;
      if (status === demand.status) option.selected = true;
      statusSelect.appendChild(option);
    });
    statusSelect.addEventListener('change', () => {
      demand.status = statusSelect.value;
      row.dataset.status = demand.status;
      applyRowStyle(row, demand);
      updateNotificationIcon();
    });
    statusCell.appendChild(statusSelect);

    row.insertCell().textContent = demand.data;
    row.insertCell().textContent = demand.descricao;
    row.insertCell().appendChild(createDownloadLink(demand.filePath));

    applyRowStyle(row, demand);
  }

  function applyRowStyle(row, demand) {
    row.classList.remove('status-pendente', 'status-execucao', 'status-concluido', 'origem-susep');
    if (demand.status === 'Concluído') {
      row.classList.add('status-concluido');
    } else if (demand.status === 'Em execução') {
      row.classList.add('status-execucao');
    } else if (demand.status === 'Pendente') {
      row.classList.add('status-pendente');
      if (demand.origem === 'Interno e SUSEP' || demand.origem === 'SUSEP') {
        row.classList.add('origem-susep');
      }
    }
  }

  form.addEventListener('submit', (e) => {
    e.preventDefault();
    const fileInput = document.getElementById('fileInput');
    const produto = document.getElementById('produto').value;
    const origem = document.getElementById('origem').value;
    const status = document.getElementById('status').value;
    const data = document.getElementById('data').value;
    const descricao = document.getElementById('descricao').value;
    const ajustesCumulativos = document.getElementById('ajustesCumulativos').checked;

    if (!fileInput.files.length) {
      alert('Por favor, selecione um arquivo.');
      return;
    }

    const filePath = URL.createObjectURL(fileInput.files[0]);

    if (ajustesCumulativos) {
      demands.forEach(d => {
        if (d.produto === produto && d.status === 'Pendente') {
          d.status = 'Concluído';
        }
      });
      backlogTbody.innerHTML = '';
      demands.forEach(d => addDemandToTable(d));
    }

    const newDemand = { produto, origem, status: 'Pendente', data, descricao, filePath };
    demands.push(newDemand);
    addDemandToTable(newDemand);
    updateNotificationIcon();

    form.reset();
    document.getElementById('data').value = today;
  });

  generateReportBtn.addEventListener('click', () => {
    if (demands.length === 0) {
      alert('Nenhuma demanda para gerar relatório.');
      return;
    }
    const csvHeader = ['Produto', 'Origem', 'Status', 'Data', 'Descrição', 'Arquivo'];
    const csvRows = demands.map(d => [
      `"${d.produto}"`, `"${d.origem}"`, `"${d.status}"`,
      `"${d.data}"`, `"${d.descricao}"`, `"${d.filePath}"`
    ]);
    const csvContent = [csvHeader, ...csvRows].map(e => e.join(';')).join('\n');
    const blob = new Blob(["\ufeff" + csvContent], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = `relatorio_${today}.csv`;
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  });

  updateNotificationIcon();
});
